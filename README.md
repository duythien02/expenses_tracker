<div align="center">
<img src="./assets/images/logo.png" alt="Logo" width="200">
</div>

# Expenses Tracker App

This is a graduation project that integrates Firebase and Flutter to build a personal financial management application

## ⚠️ Prerequisites

1. Install Flutter SDK
2. Install Firebase CLI

## Contents

Application Features:

- [ ] **Authentication**
  - [x] Email & password registration & login
  - [x] Login using various providers (Google)*

- [ ] **Database**
  - [x] CRUD operations on Firebase Cloud Firestore
  - [x] Using Realtime Database

- [ ] **Backend Actions**
  - [x] Cloud Functions
  - [x] User Presence tracking
  - [ ] Push notifications using Firebase Cloud Messaging (FCM)

- [ ] **Machine Learning**
  - [ ] Suggestions for reasonable spending proposals
     
- [ ] **Other utilities**
  - [x] Chat with AI
  - [ ] Analyze expenses, income and display it as a chart
## Plugins

For this project you have to add two plugins:

- [firebase_core](https://pub.dev/packages/firebase_core): Required for initializing Firebase and using any other Firebase plugins.
- [firebase_auth](https://pub.dev/packages/firebase_auth): For using Firebase Authentication service in Flutter.

The latest version of both these plugins support *null safety*.

## Usage

If you want to try out the this sample app, first you have to create and configure a Firebase project:

* Clone the project:
  
  ```bash
  https://github.com/duythien02/expenses_tracker.git
  ```

* Create a new Firebase project from the [console](https://console.firebase.google.com/).

* Configure the Firebase for each platform.

* Run the app using the command:
  
  ```bash
  cd expenses-tracker
  flutter run
  ```
## License

Copyright (c) 2022 DuyThien
