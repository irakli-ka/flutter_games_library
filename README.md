

# 🎮 Flutter Games Library

A  game exploration app built with Flutter. This project allows users to browse trending games, view detailed information about each game, manage a personalized library, and search for other users' collections.

## ✨ Features

- **Dynamic Game Discovery:** Real-time data fetching from the **RAWG API**.
- **User Authentication:** Custom Login/Signup flow using **Firebase Auth** with username-to-email mapping.
- **Personal Game Library:** Add/remove games from your collection, synchronized across devices via **Firebase Realtime Database**.
- **Infinite Scrolling:** Smooth pagination logic that loads 20 items at a time as the user scrolls.
- **Advanced Search & Filtering:** Comprehensive search functionality to find games by title, genre, or platform.
- **Profile Search:** Discover other users and view their game libraries by searching their username.

## 📱 Responsive Design

The application is fully adaptive for different screen sizes and orientations:
- **Mobile:** Displays a clean, single-column `SliverList`.
- **Tablet/Landscape:** Dynamically switches to a two-column `SliverGrid` using `LayoutBuilder` (700px breakpoint).
- **Safe Areas:** Implementation of `SafeArea` ensures content is never obscured by notches or status bars.

## 🏗 Modular Architecture (MVVM)

The project follows the **Feature-First MVVM** pattern for maximum maintainability:
- **Models:** Specialized models for each feature.
- **Views:** Clean UI separated into feature folders (`auth`, `games`, `profile`, `search`).
- **ViewModels (Providers):** Centralized state management using **Provider** to handle logic and UI updates.
- **Repositories:** Abstracted data layer for API calls and Firebase operations.

### 🔐 Auth Feature
- **Responsibility:** Manages user authentication and session state.
- **Logic:** Implements a custom mapping system in Firebase to allow users to log in with a **Username** instead of just an Email.
- **Validation:** Uses a shared `AuthValidationMixin` to enforce alphanumeric username requirements and password security in real-time.

### 🎮 Games Feature (Core)
- **Responsibility:** The primary data consumption layer for the RAWG API.
- **Home View:** Displays the "Popular Games" section with a custom carousel and an infinite-scrolling list of trending titles.
- **Details View:** Fetches and displays deep metadata for a specific game, including a screenshot gallery, developer information, and platform-specific data.
- **Pagination:** Handles the logic for appending the next 20 games to the state as the user scrolls.

### 👤 Profile Feature
- **Responsibility:** Manages the user's personalized experience.
- **Personal Library:** Real-time synchronization of the user's saved games using Firebase Realtime Database.
- **User Search:** A dedicated sub-feature that allows searching for other users' profiles by username to view their public game collections.

### 🔍 Search Feature
- **Responsibility:** Provides advanced exploration tools for the RAWG database.
- **Filtering:** Allows users to narrow down results by genres, stores, and other criteria.
- **State Management:** Uses a dedicated `SearchProvider` to maintain complex filter states separately from the main trending games list.

## 🛠 Tech Stack

- **Framework:** Flutter
- **State Management:** Provider
- **Networking:** Dio
- **Backend:** Firebase (Auth & Realtime Database)
- **Assets:** Flutter SVG, Lottie

   