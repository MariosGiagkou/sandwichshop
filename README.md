# Sandwich Shop App

A simple Flutter app to simulate a sandwich counter. Users can select sandwich size (six-inch or footlong), choose a bread type, add a quantity of sandwiches, and attach notes to an order. The project includes a small repository layer and unit tests for the order repository.

## Key features

- Choose between six-inch and footlong sandwiches
- Select bread type (white, wheat, wholemeal)
- Increment and decrement order quantity with limits
- Add notes to an order
- Basic unit tests for the OrderRepository logic

## Prerequisites

- OS: macOS, Windows, or Linux
- Flutter SDK (>= stable channel)
- Dart SDK (bundled with Flutter)
- An IDE (VS Code, Android Studio) or a terminal for flutter commands

Verify your environment:

```bash
flutter --version
```

## Clone and setup

1. Clone the repository:

   ```bash
   git clone <your-repo-url> c:\Users\mario\Desktop\UNI\Programming\sandwich_shop
   cd c:\Users\mario\Desktop\UNI\Programming\sandwich_shop
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app on a connected device or emulator:

   ```bash
   flutter run
   ```

   If you want to run a specific target (e.g., Windows or Android), use:

   ```bash
   flutter run -d <device-id>
   ```

## Usage

- Launch the app.
- Use the switch to toggle between six-inch and footlong.
- Use the dropdown to pick a bread type.
- Press "Add" or "Remove" to change the quantity (respecting the configured max).
- Type notes in the text field; notes are shown in the order display area.

Important flows:

- Quantity cannot go below 0.
- Quantity cannot exceed the configured maxQuantity (set in the OrderScreen constructor).
- Notes are live-updated (TextField -> controller -> display).

Screenshots / GIFs:

- Add screenshots or short GIFs of the UI here (place images inside docs/screenshots and reference them).

  Example:

  ![App screenshot](docs/screenshots/screenshot-1.png)

## Running tests

Unit tests are located in the `test` folder.

Run all tests:

```bash
flutter test
```

Example test in this project:

- test/repositeries/order_repository_test.dart — verifies increment/decrement and bounds behavior for OrderRepository.

## Project structure

- lib/
  - main.dart — main app UI and widgets (order screen, button, display).
  - views/app_styles.dart — shared text styles used by the UI.
  - repositeries/order_repository.dart — repository managing order quantity and limits.
- test/
  - repositeries/order_repository_test.dart — tests for repository logic.

Notes:

- The project currently uses the folder name `lib/repositeries` (spelling: "repositeries"). If you prefer the standard spelling (`repositories`) consider renaming the folder and updating imports accordingly.

## Technologies & dependencies

- Flutter (UI)
- Dart (language)
- flutter_test for unit tests

(See pubspec.yaml for full dependency list.)

## Known issues & future improvements

- Folder naming: `repositeries` is non-standard; renaming to `repositories` would improve clarity.
- Persistence: Orders are not persisted; consider adding local storage or a backend.
- Accessibility & localization enhancements.
- Add e2e / widget tests for UI interactions.

## Contributing

Contributions are welcome. Suggested workflow:

1. Fork the repo.
2. Create a feature branch: `git checkout -b feat/your-feature`
3. Make changes and add tests.
4. Submit a pull request with a clear description.

Be sure to run `flutter analyze` and `flutter test` before opening a PR.

## Contact

Maintainer: Mario  
Project directory: c:\Users\mario\Desktop\UNI\Programming\sandwich_shop

For questions or issues, open an issue in the repository or contact the maintainer directly.