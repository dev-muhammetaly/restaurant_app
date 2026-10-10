# 🍽️ Restaurant App

A modern Flutter restaurant ordering application with Supabase authentication, menu browsing, cart management, profile access, and order history.

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.12.2-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase" alt="Supabase" />
  <img src="https://img.shields.io/badge/Status-Preview-orange" alt="Status" />
</p>

## Overview

This project is a Flutter-based restaurant ordering app designed for mobile-style user experience. It includes:

- Sign in / sign up flow with Supabase Auth
- Restaurant menu with category filtering
- Cart management with quantity control
- User profile screen
- Order history screen
- Animated UI states using Lottie
- Responsive preview support for design testing

## Tech Stack

- Flutter
- Dart
- Riverpod for state management
- Supabase for authentication and backend data
- Lottie for animations
- Device Preview for responsive UI testing

## App Features

- Restaurant menu with category tabs: All, Soups, Salads, Drinks
- Real-time fetching of menu data from a Supabase `menu` table
- Add/remove products to cart
- Cart badge count updates in bottom navigation
- Authentication gate that redirects logged-in users to the app
- Profile and order tracking screens
- Clean Material 3 design with orange theme

## Project Structure

```text
restaurant_app/
├── android/
├── ios/
├── linux/
├── macos/
├── windows/
├── web/
├── assets/
│   ├── ForkAndKnife.json
│   ├── emptyCart.json
│   ├── loginFork.json
│   └── fonts/
├── lib/
│   ├── models/
│   │   ├── cart_item.dart
│   │   ├── menu_item.dart
│   ├── providers/
│   │   ├── auth_provider.dart
│   │   ├── cart_providers.dart
│   │   └── menu_provider.dart
│   ├── screens/
│   │   ├── auth_gate.dart
│   │   ├── cart_screen.dart
│   │   ├── home_screen.dart
│   │   ├── login_screen.dart
│   │   ├── main_navigation_screen.dart
│   │   ├── order_history_screen.dart
│   │   └── profile_screen.dart
│   ├── widgets/
│   └── main.dart
├── test/
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── README.md
└── pubspec.lock
```

## Prerequisites

Before running this project, make sure you have:

- Flutter SDK installed
- A Supabase project created
- A configured mobile or web emulator/device
- Basic understanding of Flutter and Dart

## Setup Instructions

1. Clone the repository

```bash
git clone https://github.com/dev-muhammetaly/restaurant_app.git
cd restaurant_app
```

2. Install dependencies

```bash
flutter pub get
```

3. Configure Supabase

This project currently initializes Supabase directly in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  publishableKey: 'your-publishable-key',
);
```

Replace the placeholder values with your own Supabase project credentials.

4. Create the required Supabase tables and authentication configuration

The app is designed to work with:

- `menu` table for restaurant items
- Supabase Auth for login/signup
- user metadata such as `full_name` and `phone`

If your Supabase schema is different, update the model/provider code accordingly.

5. Run the app

```bash
flutter run
```

## Important Manual Setup Notes

This project is already structured well, but a few things are still project-specific and should be customized manually:

- Add your real Supabase URL and keys in `lib/main.dart`
- Replace the default app name and branding text if needed
- Add your own menu data to Supabase
- Customize the app theme colors and visual identity
- Add screenshots for GitHub and app store previews
- Replace placeholder package metadata in `pubspec.yaml`
- Review the design if you want a more premium restaurant brand look

## Supabase Data Expectations

The menu provider expects a `menu` table with fields similar to:

```text
id
name
description
price
image_url
category
```

The authentication flow sends signup metadata including:

```text
full_name
phone
```

## Screens Included

- Login / Sign Up screen
- Home menu screen
- Cart screen
- Profile screen
- Order history screen
- Authentication gate

## Notes for README polish

This README is intentionally clean and professional, but you can improve it further by adding:

- app screenshots
- a live demo link
- architecture diagram
- licensing section
- contribution guidelines
- environment variable examples

## Recommended Next Manual Improvements

Before publishing or sharing the repo publicly, consider doing these manually:

1. Update the project description in `pubspec.yaml`
2. Add a real app logo and splash screen
3. Add app screenshots in a `screenshots/` folder
4. Write a stronger product description for the GitHub page
5. Add a `.env.example` file if you later switch to environment variables
6. Add proper app store / Play Store metadata

## License

This project currently has no explicit license file. If you plan to publish it, add a license such as MIT.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

This README was prepared to make the repository look clean and professional while keeping it accurate to the project structure and codebase.

If you want, I can also make a second version of the README in a more premium style for a restaurant brand, with a stronger visual layout and more marketing-oriented wording.
