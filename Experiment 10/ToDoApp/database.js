// database.js
import { initializeApp } from "firebase/app";
import {
    getFirestore,
    collection,
    addDoc,
    doc,
    updateDoc,
    deleteDoc
} from "firebase/firestore";

// Firebase config
const firebaseConfig = {
    apiKey: "AIzaSyCIHIEhQg0bW2qV4N8VuKEE_Nx0hRGv_94",
    authDomain: "mytodoapp-6de73.firebaseapp.com",
    projectId: "mytodoapp-6de73",
    storageBucket: "mytodoapp-6de73.appspot.com",
    messagingSenderId: "864340987109",
    appId: "1:864340987109:web:7c4416fd65e0cc9a02580c",
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const firestoreDB = getFirestore(app);
const tasksCol = collection(firestoreDB, "tasks");

// ➕ Add task
export const addTask = async (text) => {
    try {
        const docRef = await addDoc(tasksCol, {
            text,
            completed: false,
            createdAt: Date.now(),
        });
        return docRef.id; // ✅ Return Firestore ID
    } catch (err) {
        console.error("🔥 Firebase addTask error:", err);
        return null;
    }
};

// ✏️ Update task text
export const updateTask = async (firebaseId, newText) => {
    try {
        const taskDoc = doc(firestoreDB, "tasks", firebaseId);
        await updateDoc(taskDoc, { text: newText });
    } catch (err) {
        console.error("🔥 Firebase updateTask error:", err);
    }
};

// ✅ Toggle completion
export const toggleTask = async (firebaseId, completed) => {
    try {
        const taskDoc = doc(firestoreDB, "tasks", firebaseId);
        await updateDoc(taskDoc, { completed });
    } catch (err) {
        console.error("🔥 Firebase toggleTask error:", err);
    }
};

// ❌ Delete task
export const deleteTask = async (firebaseId) => {
    try {
        const taskDoc = doc(firestoreDB, "tasks", firebaseId);
        await deleteDoc(taskDoc);
    } catch (err) {
        console.error("🔥 Firebase deleteTask error:", err);
    }
};

export { firestoreDB };