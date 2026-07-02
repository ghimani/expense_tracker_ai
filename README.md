# Expense Tracker AI

AI-powered Expense Tracker built using Flutter, BLoC, Hive, and Gemini AI.

## Features

- Add Expense
- Edit Expense
- Delete Expense
- Receipt Scanner using Gemini AI
- Camera Support
- Gallery Support
- AI Spending Insights
- Hive Local Storage
- BLoC State Management
- Expense Categories
- Auto-fill Expense from Receipt

## Tech Stack

- Flutter
- Dart
- Flutter BLoC
- Hive Database
- Gemini AI
- Image Picker

## Architecture

- Presentation Layer
    - Screens
    - BLoC

- Data Layer
    - Models
    - Repository

- Core Layer
    - Gemini Service

## Screens

- Home Screen
- Add Expense Screen
- Receipt Scanner Screen
- AI Spending Insights Screen

## Setup

1. Clone repository
2. Create `.env` file
3. Add Gemini API key

```env
GEMINI_API_KEY=YOUR_API_KEY
```

4. Run project

```bash
flutter pub get
flutter run
```

## Author

Himani Gupta
Android & Flutter Developer