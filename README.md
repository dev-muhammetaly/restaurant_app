# Restaurant App

A Flutter restaurant-ordering project. Users can sign in, browse the menu, add food to a cart and place an order. The menu and order history come from Supabase.

[Try the web demo](https://m-restaurant-app.netlify.app)

## What is included

- Email registration and sign-in
- Menu categories and item details
- Cart quantities and a running total
- Order submission and order history
- A profile screen

The app uses Riverpod for state management and Material 3 for the interface. Placing an order saves it to the database; there is no payment gateway.

## Run locally

Install Flutter, open the project folder, then run:

```sh
flutter pub get
flutter run
```

The Supabase connection is configured in `lib/main.dart`. For your own instance, replace the project URL and publishable key. You also need authentication and compatible `menu` and `orders` tables. The expected fields are in `lib/models/menu_item.dart` and `lib/providers/cart_providers.dart`.

A database setup script is not included, so cloning the Flutter code alone does not create a new backend.

## Where to start reading

Screens are in `lib/screens/`. Menu loading, authentication and cart/order logic live in `lib/providers/`. Development builds also enable Device Preview for checking different screen sizes.
