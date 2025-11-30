# 📱 Task Tracker App: Bloc State Management & Data Persistence

**Project Name:** `bloc_persistence_app`

## 🎯 Project Overview & Objectives

This is a minimal Flutter application developed to demonstrate the correct usage of the **Bloc (Cubit)** pattern for state management and to implement **local data persistence**. The main objective was to create a fully functional task list that saves all changes and loads data successfully across app sessions.

## ✨ Functional Requirements Implemented

The application successfully meets all the specified requirements:

* **Add/Display Items:** Users can add new tasks (with title and description) and view them in a scrollable list.
* **Update Status:** Tasks can be marked as complete or incomplete (toggle completion status).
* **Update Content:** Tasks can be edited (title and description) on a separate screen.
* **Delete Item:** Tasks can be permanently deleted from the list.
* **State Handling:** All user interactions and state transitions are managed exclusively through the **TaskCubit**.
* **Data Persistence:** All changes (Add, Update, Delete) are saved **locally** using the **Repository Pattern** and are loaded immediately upon app startup.

## 🧱 Architectural Components

The project architecture clearly separates concerns using the following key components:

| Component | Technology/Pattern | Responsibility |
| :--- | :--- | :--- |
| **State Management** | **TaskCubit** (`flutter_bloc`) | Handles all business logic and emits the new state (`List<Task>`) to the UI. |
| **Data Handling** | **TaskRepository** | Abstracted layer responsible for fetching and saving data from the storage medium. |
| **Persistence** | **SharedPreferences** | The chosen local storage mechanism for persisting task data (stored as JSON). |
| **Data Model** | **Task** (Model) | Provides the structure for the data, including `toJson` and `fromJson` methods for serialization. |

## 🚀 Getting Started

This project is a starting point for a Flutter application. For assistance with development, view the online documentation:

* **Lab:** [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
* **Cookbook:** [Useful Flutter samples](https://docs.flutter.dev/cookbook)