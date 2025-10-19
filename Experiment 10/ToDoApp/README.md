# My To-Do App

A simple **React Native To-Do application** that allows users to:

- Add, update, delete, and mark tasks as completed.
- Store tasks locally in **SQLite** for offline support.
- Sync tasks with **Firebase Firestore** for cloud persistence.

---

## Features

- **Add Tasks**: Create new tasks and save them locally and on Firebase.
- **Edit Tasks**: Update task text seamlessly.
- **Delete Tasks**: Remove tasks both locally and from Firebase.
- **Toggle Completion**: Mark tasks as complete or incomplete.
- **Offline Support**: Tasks are stored locally using SQLite.
- **Cloud Sync**: All changes are mirrored on Firebase Firestore.

---

## Tech Stack

- **Frontend**: React Native  
- **Local Storage**: SQLite (`expo-sqlite`)  
- **Backend / Cloud Storage**: Firebase Firestore  
- **Language**: TypeScript  

---

## Usage

- **Add a Task**: Enter text in the input field and tap +.
- **Update a Task**: Tap the ✏️ icon, edit the text, then tap ✔.
- **Delete a Task**: Tap the ❌ icon.
- **Mark Complete/Incomplete**: Tap on the task text.

---

## Notes

- **Firebase Integration**: Ensure your Firebase project configuration in database.ts is correct.
- **SQLite**: All tasks are stored locally for offline use.
- **ID Mapping**: Each SQLite task stores the corresponding firebase_id to sync changes with Firebase.

---
