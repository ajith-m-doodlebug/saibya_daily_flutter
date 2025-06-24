# SAIBYA Daily - Flutter App

A modern wellness tracking mobile application built with Flutter that helps users monitor their daily health metrics including sleep, mood, hydration, and meals.

## 📱 Features

- **🔐 Phone Authentication**: Secure OTP-based login system
- **📊 Wellness Tracking**: Log daily sleep hours, mood ratings, hydration levels, and meals
- **📈 Statistics Dashboard**: Visual representation of weekly wellness data
- **💡 Health Tips**: Daily health and wellness recommendations
- **🎯 Streak Tracking**: Motivation through consecutive day tracking
- **📱 Offline Support**: Local data storage for offline access

## 🛠️ Tech Stack

- **Flutter** - Cross-platform mobile framework
- **Dart** - Programming language
- **Bloc** - State management
- **Dio** - HTTP networking
- **SharedPreferences** - Local storage
- **FL Chart** - Data visualization

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/saibya-daily-flutter.git
cd saibya-daily-flutter
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Configure the backend URL
Update the backend URL in `lib/Config/environment.dart`:
```dart
class Environment {
  static const String apiBaseUrl = 'http://10.0.2.2:8000'; // For local development
  // static const String localUrl = 'https://your-api-url.com'; // For production
}
```

### 4. Generate splash screen and app icons
```bash
flutter pub run flutter_native_splash:create
flutter pub run flutter_launcher_icons
```

### 5. Run the app
```bash
# For debug mode
flutter run

# For release mode
flutter run --release
```



## 📱 Screens

### Authentication Flow
1. **Phone Number Input** - Enter phone number
2. **OTP Verification** - Enter received OTP
3. **Registration** - New user name input

### Main Features
1. **Home Dashboard** - Overview with stats and health tips
2. **Add Log** - Create daily wellness entries
3. **View Logs** - Historical data view
4. **Statistics** - Weekly averages and trends

# saibya_daily_flutter
