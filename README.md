# Cosmotiva

**Cosmotiva** is a premium cosmetics-analysis application built with Flutter. It leverages the power of AI to help users understand the ingredients in their cosmetic products, ensuring they make informed decisions about what they apply to their skin.

## 🚀 Features

*   **AI-Powered Analysis**: Utilizes Google's Gemini AI to analyze product ingredients and provide detailed insights.
*   **Ingredient Scanning**: Scan product labels (feature in development) or input ingredients manually for instant analysis.
*   **Safety Ratings**: Get safety ratings and potential hazard warnings for each ingredient.
*   **User Authentication**: Secure login and signup functionality powered by Firebase Authentication.
*   **History & Favorites**: Save your analyzed products to your history or mark them as favorites for quick access.
*   **Premium UI/UX**: A sleek, dark-themed interface designed for a premium user experience.
*   **Monetization**: Integrated Google Mobile Ads for sustainable app development.

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Language**: [Dart](https://dart.dev/)
*   **State Management**: [Riverpod](https://riverpod.dev/)
*   **Backend / Auth**: [Firebase](https://firebase.google.com/) (Auth, Core, Firestore)
*   **AI**: [Google Gemini API](https://ai.google.dev/)
*   **Ads**: [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads)
*   **Local Storage**: [Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage)

## 📂 Project Structure

The project follows **Clean Architecture** principles to ensure scalability and maintainability:

```
lib/
├── core/           # Core utilities, constants, and errors
├── data/           # Data layer (API calls, local storage implementations)
├── domain/         # Domain layer (Entities, Repository interfaces, Use cases)
├── presentation/   # UI layer (Pages, Widgets, ViewModels/Providers, Theme)
├── services/       # External services (Auth, AI, Ads, etc.)
└── main.dart       # App entry point
```

## 📐 Architecture & Design

### Use Case Diagram
![Use Case Diagram](diagrams/1_Use_Case_Diagram.png)

### Class Diagram
![Class Diagram](diagrams/2_Class_Diagram.png)

### Sequence Diagram (Scan Feature)
![Sequence Diagram](diagrams/3_Sequence_Diagram_Scan_Feature.png)

### Activity Diagram (Onboarding)
![Activity Diagram](diagrams/4_Activity_Diagram_User_Onboarding_Flow.png)

### Deployment Diagram
![Deployment Diagram](diagrams/4_deploymentdiagram.png)

## 🏁 Getting Started

### Prerequisites

*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   An IDE (VS Code or Android Studio) with Flutter plugins.
*   A Firebase project set up.
*   A Google Gemini API key.

### Installation

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/codnizer/cosmotiva_app.git
    cd cosmotiva
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Configure Firebase:**
    *   Ensure you have the `flutterfire_cli` installed.
    *   Run `flutterfire configure` to generate `firebase_options.dart`.

4.  **Environment Setup:**
    *   Create a `.env` file in the root directory (if using `flutter_dotenv`, otherwise check `lib/core/constants.dart` for API key configuration).
    *   *Note: Currently, the API key might be hardcoded in `lib/main.dart` or `lib/core/constants.dart` for development. Ensure to secure this for production.*

5.  **Run the app:**
    ```bash
    flutter run
    ```

## 📱 Screenshots

### Onboarding
<img src="screens/1_onboarding_screen_1.png" width="200" /> <img src="screens/2_onboarding_screen2.png" width="200" /> <img src="screens/3_onboarding_screen3.png" width="200" />

### Authentication
<img src="screens/4_sign_up_1.png" width="200" /> <img src="screens/5_signup_2_completprofile_and_set_skintype_and_allergies.png" width="200" />

### Scanning & Analysis
<img src="screens/6_home_scanpage.png" width="200" /> <img src="screens/7_scan with cameara.png" width="200" /> <img src="screens/8_analyzing_product_inprogress.png" width="200" />
<img src="screens/9_analyze_result.png" width="200" /> <img src="screens/10_suggested alternative products.png" width="200" />

### Profile & History
<img src="screens/11_favorites_page.png" width="200" /> <img src="screens/12_scan_history_page.png" width="200" /> <img src="screens/13_profile_prefernces_page.png" width="200" />

### Monetization
<img src="screens/14_clicking_watchvideoad_to_earn_one_credit_currentcredit_is_2.png" width="200" /> <img src="screens/15_rewardad_playing.png" width="200" /> <img src="screens/16_credit+1_after_watching_ad_now_credits_is_3.png" width="200" />

 
# cosmotiva_app
# cosmotiva_app
# cosmotiva_app
