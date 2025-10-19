// firebaseService.ts
import { firestoreDB } from "./firebaseConfig";
import {
    collection,
    addDoc,
    getDocs,
    updateDoc,
    deleteDoc,
    doc,
} from "firebase/firestore";

const tasksCollection = collection(firestoreDB, "tasks");

// Fetch tasks from Firestore
export const fetchFirestoreTasks = async () => {
    const snapshot = await getDocs(tasksCollection);
    return snapshot.docs.map((doc) => ({
        id: doc.id,
        text: doc.data().text,
        completed: doc.data().completed,
    }));
};

// Add task to Firestore
export const addFirestoreTask = async (text: string) => {
    await addDoc(tasksCollection, { text, completed: false });
};

// Update task text
export const updateFirestoreTask = async (id: string, text: string) => {
    const taskDoc = doc(firestoreDB, "tasks", id);
    await updateDoc(taskDoc, { text });
};

// Toggle completion
export const toggleFirestoreTask = async (id: string, completed: boolean) => {
    const taskDoc = doc(firestoreDB, "tasks", id);
    await updateDoc(taskDoc, { completed });
};

// Delete task
export const deleteFirestoreTask = async (id: string) => {
    const taskDoc = doc(firestoreDB, "tasks", id);
    await deleteDoc(taskDoc);
};