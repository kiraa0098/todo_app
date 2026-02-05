# Project Architecture Guide

## Overview

This document describes a recommended architecture and folder structure for Flutter projects, based on a deep scan of a previous codebase. It is designed to help you maintain consistency and best practices for your new TODO app or similar projects.

---

## Top-Level Structure

- **lib/**: Main source code for the Flutter app.
- **assets/**: Static assets (images, SVGs, Rive animations, etc.).
- **android/**, **ios/**, **macos/**, **linux/**, **windows/**, **web/**: Platform-specific code and configuration.
- **test/**: Test files.

---

## lib/ Folder Structure

### Core Files

- **main.dart**: App entry point.
- **main_dev.dart**, **main_local.dart**, etc.: Environment-specific entry points.
- **app.dart**: Root widget or app configuration.
- **app_theme.dart**: Theme and styling definitions.
- **colors.dart**: Color palette.
- **firebase_options.dart**: Firebase configuration.
- **splash_screen_wrapper.dart**: Splash screen logic.
- **test_area.dart**: Development/testing widgets.

### api/

- API base classes, environment configs, global settings, and response models.

### common/

- **abstract/**: Abstract classes/utilities.
- **function/**: Utility functions (image cropping, file upload, validators, etc.).
- **helper/**: Helper classes for formatting, navigation, color, date/time, etc.
- **types/**: Custom types/enums.
- **widgets/**: Reusable UI widgets, organized by feature or type.

### constants/

- App-wide constants and UI settings.

### features/

Organized by domain/feature. Each feature should have its own substructure:

- **<feature_name>/**: e.g., todo/
  - **api/**: API calls and data sources for the feature.
  - **models/**: Data models for the feature.
  - **screens/**: UI screens.
  - **widgets/**: Feature-specific widgets.

#### Example Feature Substructure (todo):

- **api/**: API calls and data sources for TODOs.
- **models/**: Data models for TODO items.
- **screens/**: UI screens for listing, editing, and viewing TODOs.
- **widgets/**: Feature-specific widgets (e.g., TODO item card).

---

## assets/

- **images/**: App images.
- **icons-svg/**, **svg/**: SVG icon assets.
- **rive_animation/**: Rive animation files.
- **drawer/**: Drawer-related assets.
- **profile-images/**: Profile images.

---

## Technologies & Concepts Used

- **Flutter**: Main framework.
- **BLoC (flutter_bloc)**: State management.
- **Equatable**: Value equality for BLoC/events.
- **Firebase**: Authentication and backend.
- **Dio, http**: Networking.
- **Shared Preferences, Secure Storage**: Local storage.
- **Permission Handler**: Permissions management.
- **Image Picker, Cropper**: Media handling.
- **Rive**: Animations.
- **SVG, PDF, Excel, etc.**: File handling.
- **Custom Navigation**: Custom page route builders.
- **Theming**: Custom theme and color management.
- **Reusable Widgets**: Modular, feature-based widget structure.
- **Environment Configs**: Multiple main files for different environments.

---

## How to Adapt for a TODO App

- Create a new folder under **features/** (e.g., features/todo/).
- Follow the substructure: api/, models/, screens/, widgets/.
- Use BLoC for state management.
- Add new types/enums to **common/types/**.
- Add helpers to **common/helper/** if needed.
- Add reusable widgets to **common/widgets/** if they are generic.
- Register new routes/screens in the shell or main_screen as appropriate.

---

## Notes

- The architecture is modular and feature-driven.
- Heavy use of helpers and utility classes for DRY code.
- Navigation is custom, not using go_router.
- Ready for multi-environment builds and strong separation of concerns.

---

_Use this guide to keep your new project consistent and maintainable._
