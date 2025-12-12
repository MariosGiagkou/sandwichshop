# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart, and it is designed primarily to be run in a web
browser.

## Recent Updates

### Firebase Integration
- **Firebase Core 3.0.0** - Added Firebase authentication and real-time database support
- **Cloud Firestore** - User profiles (name & location) are saved to Firestore
- **Multi-platform Support** - Firebase configured for Web, Android, iOS, macOS, and Windows

### Testing & Quality Assurance
- **Comprehensive Integration Tests** - 25+ integration tests covering all user journeys
- **Test Coverage Documentation** - Detailed test coverage report in `INTEGRATION_TEST_COVERAGE.md`
- **Automated Testing** - Tests for cart operations, navigation, pricing, checkout, and profile validation

### Build & Performance
- **Release Build Optimization** - 52% smaller release builds (128.86 MB → 61.47 MB)
- **Performance Comparison** - Detailed debug vs release analysis in `BUILD_COMPARISON.md`
- **Windows Support** - Successfully building for Windows desktop platform

### Features
- Profile screen with Firebase integration
- Persistent order history using SQLite
- Shopping cart with state management (Provider)
- Multiple sandwich customization options
- Settings persistence with SharedPreferences

## Install the essential tools

1. **Terminal**:

    - **macOS** – use the built-in Terminal app by pressing **⌘ + Space**, typing **Terminal**, and pressing **Return**.
    - **Windows** – open the start menu using the **Windows** key. Then enter **cmd** to open the **Command Prompt**. Alternatively, you can use **Windows PowerShell** or **Windows Terminal**.

2. **Git** – verify that you have `git` installed by entering `git --version`, in the terminal.
    If this is missing, download the installer from [Git's official site](https://git-scm.com/downloads?utm_source=chatgpt.com).

3. **Package managers**:

    - **Homebrew** (macOS) – verify that you have `brew` installed with `brew --version`; if missing, follow the instructions on the [Homebrew installation page](https://brew.sh/).
    - **Chocolatey** (Windows) – verify that you have `choco` installed with `choco --version`; if missing, follow the instructions on the [Chocolatey installation page](https://chocolatey.org/install).

4. **Flutter SDK** – verify that you have `flutter` installed and it is working with `flutter doctor`; if missing, install it using your package manager:

    - **macOS**: `brew install --cask flutter`
    - **Windows**: `choco install flutter`

5. **Visual Studio Code** – verify that you have `code` installed with `code --version`; if missing, use your package manager to install it:

    - **macOS**: `brew install --cask visual-studio-code`
    - **Windows**: `choco install vscode`

## Get the code

### If this is your first time working on this project

Enter the following commands in your terminal to clone the repository and
open it in Visual Studio Code.
You may want to change directory (`cd`) to the directory where you want to clone the
repository first.

```bash
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

### If you have already cloned the repository

Enter the following commands in your terminal to switch to the correct branch.
Remember to `cd` to the directory where you cloned the repository first.

```bash
git fetch origin
git checkout 8
```

## Run the app

Open the integrated terminal in Visual Studio Code by first opening the Command
Palette with **⌘ + Shift + P** (macOS) or **Ctrl + Shift + P** (Windows) and
typing **Terminal: Create New Terminal** then pressing **Enter**.

In the terminal, run the following commands to install the dependencies and run
the app in your web browser:

```bash
flutter pub get
flutter run
```

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).

## Running Tests

### Integration Tests
Run the comprehensive integration test suite:

```bash
flutter test integration_test/comprehensive_test.dart
```

For web integration tests with Chrome:
```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/comprehensive_test.dart -d chrome
```

### Unit & Widget Tests
Run all unit and widget tests:

```bash
flutter test
```

## Building for Production

### Debug Build (for development)
```bash
flutter build windows --debug
```

### Release Build (optimized for production)
```bash
flutter build windows --release
```

See `BUILD_COMPARISON.md` for detailed performance metrics and size comparisons.

## Project Structure

- `lib/models/` - Data models (Cart, Sandwich, SavedOrder)
- `lib/services/` - Business logic (DatabaseService, PricingRepository)
- `lib/views/` - UI screens (OrderScreen, CartScreen, ProfileScreen, etc.)
- `lib/widgets/` - Reusable UI components
- `integration_test/` - Integration test suites
- `test/` - Unit and widget tests

## Known Issues

### Windows Build with Firebase
If you encounter CMake compatibility errors when building for Windows with Firebase:
- Firebase SDK requires CMake < 3.5 compatibility
- Workaround: Temporarily comment out Firebase dependencies in `pubspec.yaml` for Windows builds
- Firebase works without issues on Web, Android, iOS, and macOS platforms

