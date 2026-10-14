# 🍽️ Restaurant App

Modern restaurant ordering app built with Flutter and Supabase. The app lets users sign in, browse menu items, add dishes to the cart, manage their profile, and enjoy a clean restaurant-style experience.

<p align="center">
  <a href="https://m-restaurant-app.netlify.app" target="_blank">
    <img src="https://img.shields.io/badge/Live%20Demo-Netlify-00C7B7?style=for-the-badge&logo=netlify" alt="Live Demo" />
  </a>
</p>

## Live Demo

- Website: https://m-restaurant-app.netlify.app

## Overview

This project is a Flutter-based restaurant ordering app designed for a premium dining experience. It includes:

- login and sign-up flow
- menu browsing by category
- cart and checkout experience
- profile management
- order history support
- animated loading states
- responsive UI for web/mobile-like usage

## Tech Stack

- Flutter
- Dart
- Riverpod
- Supabase
- Lottie
- Material 3 UI

## Features

- Clean and modern restaurant-themed interface
- Category filtering: All, Soups, Salads, Drinks
- Real menu data loaded from Supabase
- Authentication using Supabase Auth
- Cart badge updates in navigation
- Smooth user flow from login to ordering
- Responsive layout suitable for web and mobile screens

## Screenshots

Add these images into the `docs/screenshots/` folder to display them in the README:

```text
docs/screenshots/
├── login.png
├── signup.png
├── menu.png
├── profile.png
```

Then use:

```md
![Login Screen](docs/screenshots/login.png)
![Sign Up Screen](docs/screenshots/signup.png)
![Menu Screen](docs/screenshots/menu.png)
![Profile Screen](docs/screenshots/profile.png)
```

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
│   │   └── menu_item.dart
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
├── .metadata
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── README.md
└── .gitignore
```

## Prerequisites

Before running this project, make sure you have:

- Flutter SDK installed
- A Supabase project created
- An emulator/device or browser for testing
- Basic Flutter and Dart knowledge

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

Update the credentials in `lib/main.dart`:

```dart
await Supabase.initialize(
  url: 'https://your-project.supabase.co',
  publishableKey: 'your-publishable-key',
);
```

4. Run the app

```bash
flutter run
```

## Supabase Requirements

This app expects a Supabase backend with:

- authentication enabled
- a `menu` table with fields like:
  - `id`
  - `name`
  - `description`
  - `price`
  - `image_url`
  - `category`

The app also uses user metadata such as:

- `full_name`
- `phone`

## Important Notes

This project is already built and working, but before production use you should customize the following manually:

- replace Supabase credentials with your own
- add your own real menu data
- update branding and visual identity
- add your own app assets and logo
- configure app screenshots for marketing use
- add a proper license if needed

## Recommended Improvements

To make the app production-ready, consider adding:

- dark mode
- payment integration
- admin dashboard for menu management
- stronger branding and custom assets
- order confirmation flow
- smoother cart and checkout UX

## License

This project does not currently include a license file. If you plan to publish or distribute it publicly, consider adding an MIT license.

## Author

Built as a modern restaurant ordering app prototype for web and mobile experiences.

---

This repository is ready for development and can be used as a strong starter for a restaurant app with a premium design and Supabase backend.
