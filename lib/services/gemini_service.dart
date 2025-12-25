import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cosmotiva/core/constants.dart';
import 'package:cosmotiva/core/errors/exceptions.dart';
import 'package:cosmotiva/domain/entities/product.dart';
import 'package:cosmotiva/domain/entities/user_profile.dart';
import 'package:uuid/uuid.dart';

class GeminiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final _uuid = const Uuid();

  GeminiService(this._dio, this._secureStorage);

  Future<Product> analyzeImage(File image, UserProfile user) async {
    final apiKey =
        await _secureStorage.read(key: AppConstants.GEMINI_API_KEY_STORAGE_KEY);

    if (apiKey == null || apiKey == AppConstants.GEMINI_API_KEY_PLACEHOLDER) {
      throw ApiKeyMissingException();
    }

    final String base64Image = base64Encode(await image.readAsBytes());

    final url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$apiKey';

    print('Calling Gemini API: $url');

    final prompt = '''
    Analyze this cosmetic product image. The user has ${user.skinType} skin and is allergic to: ${user.allergies.join(', ')}.
    Extract the following details in strict JSON format:
    {
      "name": "Product Name",
      "ingredients": [
        {"name": "Ingredient 1", "isHarmful": false, "description": "Safe"},
        {"name": "Ingredient 2", "isHarmful": true, "description": "Potential irritant"}
      ],
      "score": 85.5,
      "riskLevel": "Low",
      "skinCompatibility": ["Oily", "Combination"],
      "alternatives": [
        {"name": "Alternative 1", "reason": "Better ingredients"}
      ]
    }
    If you cannot identify the product, return null for name.
    In your analysis, specifically flag if any ingredients match the user's allergies or are bad for their skin type. If a match is found, set 'riskLevel' to High.
    Risk levels: Low, Moderate, High.
    Score: 0-100 (100 is best).
    ''';

    final data = {
      "contents": [
        {
          "parts": [
            {"text": prompt},
            {
              "inline_data": {"mime_type": "image/jpeg", "data": base64Image}
            }
          ]
        }
      ]
    };

    int attempts = 0;
    while (attempts < 3) {
      try {
        final response = await _dio.post(
          url,
          data: data,
          options: Options(
            contentType: 'application/json',
            validateStatus: (status) => status! < 500,
          ),
        );

        print('DEBUG: Response Status: ${response.statusCode}');
        print('DEBUG: Response Body: ${response.data}');

        if (response.statusCode == 200) {
          return _parseResponse(response.data);
        } else {
          throw GeminiAnalysisException(
              'Gemini API Error: ${response.statusCode} - ${response.data}');
        }
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          attempts++;
          await Future.delayed(Duration(seconds: 2 * attempts));
        } else {
          final errorMsg = e.response?.data ?? e.message;
          print('DEBUG: Dio Error: $errorMsg');
          throw GeminiAnalysisException('Network error: $errorMsg');
        }
      } on GeminiAnalysisException {
        rethrow;
      } catch (e) {
        print('DEBUG: Unexpected Error: $e');
        throw GeminiAnalysisException('Unexpected error: $e');
      }
    }
    throw GeminiAnalysisException('Failed after 3 attempts');
  }

  Product _parseResponse(Map<String, dynamic> data) {
    try {
      final content = data['candidates'][0]['content']['parts'][0]['text'];

      final cleanJson =
          content.replaceAll('```json', '').replaceAll('```', '').trim();
      final jsonMap = jsonDecode(cleanJson);

      return Product(
        id: _uuid.v4(),
        name: jsonMap['name'] ?? 'Unknown Product',
        ingredients: (jsonMap['ingredients'] as List?)
                ?.map((e) => Ingredient(
                      name: e['name'],
                      isHarmful: e['isHarmful'] ?? false,
                      description: e['description'],
                    ))
                .toList() ??
            [],
        score: (jsonMap['score'] as num?)?.toDouble() ?? 0.0,
        riskLevel: jsonMap['riskLevel'] ?? 'Unknown',
        skinCompatibility:
            List<String>.from(jsonMap['skinCompatibility'] ?? []),
        alternatives: (jsonMap['alternatives'] as List?)
                ?.map((e) => ProductSuggestion(
                      name: e['name'],
                      reason: e['reason'],
                    ))
                .toList() ??
            [],
        timestamp: DateTime.now(),
      );
    } catch (e) {
      throw GeminiAnalysisException('Failed to parse Gemini response: $e');
    }
  }
}
