class UserProfile {
  final String uid;
  final String email;
  final String name;
  final String skinType;
  final List<String> allergies;
  final int dailyCredits;
  final DateTime lastResetDate;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.skinType,
    required this.allergies,
    required this.dailyCredits,
    required this.lastResetDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'skinType': skinType,
      'allergies': allergies,
      'dailyCredits': dailyCredits,
      'lastResetDate': lastResetDate.toIso8601String(),
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      skinType: map['skinType'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      dailyCredits: map['dailyCredits']?.toInt() ?? 0,
      lastResetDate: map['lastResetDate'] != null
          ? DateTime.parse(map['lastResetDate'])
          : DateTime.now(),
    );
  }

  UserProfile copyWith({
    String? uid,
    String? email,
    String? name,
    String? skinType,
    List<String>? allergies,
    int? dailyCredits,
    DateTime? lastResetDate,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      skinType: skinType ?? this.skinType,
      allergies: allergies ?? this.allergies,
      dailyCredits: dailyCredits ?? this.dailyCredits,
      lastResetDate: lastResetDate ?? this.lastResetDate,
    );
  }
}
