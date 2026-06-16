# CLAUDE.md

## Project Overview

This project uses:

* Flutter
* GetX
* Dio
* SharedPreferences

Follow the existing project structure and do not change architecture without approval.

---

## Folder Structure

lib
|-routes
|-screen
|-services
|-utils
|-widgets
main.dart

Keep code organized.

* Screens for UI
* Services for API calls and local storage
* Widgets for reusable UI components
* Utils for AppColors, AppStrings, asset paths, API constants, and other shared values used across the app

---

## GetX Rules

Use GetX for:

* Navigation
* State Management
* Dependency Injection

Examples:
```dart
Get.to();
Get.back();
Get.put();
Get.find();
```

Do not create controller objects directly inside screens.

Bad:

```dart
final controller = HomeController();
```

Good:

```dart
final controller = Get.find<HomeController>();
```

---

## API Rules

Use Dio for all API calls.

Create API methods inside Services.

Do not write API calls inside UI code.

---

## Shared Preferences

Use SharedPreferences through a service.

Do not access SharedPreferences directly from widgets.

---

## UI Rules

If a widget is reused multiple times, move it to widgets folder.

Examples:

* Custom Button
* Custom TextField
* Loader
* Empty State

Avoid duplicate UI code.

---

## Code Style

* Use meaningful variable names
* Keep functions small
* Use const where possible
* Remove unused code
* Follow null safety

---

## Before Writing Code

Always check:

1. Is there already a service for this?
2. Is there already a controller for this?
3. Can an existing widget be reused?
4. Does it follow project structure?

---

## Common Packages

* flutter
* get
* dio
* shared_preferences
* image_picker
* file_picker
* cached_network_image
* flutter_svg
* intl
* pinput
* flutter native splash

Use existing packages before suggesting new ones.

---

## Never Do

* API calls inside Widgets
* Business logic inside Screens
* Duplicate Controllers
* Direct Dio calls from UI
* Hardcoded API URLs everywhere
* Creating new architecture without approval
