// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyCIHIEhQg0bW2qV4N8VuKEE_Nx0hRGv_94",
    authDomain: "mytodoapp-6de73.firebaseapp.com",
    projectId: "mytodoapp-6de73",
    storageBucket: "mytodoapp-6de73.firebasestorage.app",
    messagingSenderId: "864340987109",
    appId: "1:864340987109:web:7c4416fd65e0cc9a02580c"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const firestoreDB = getFirestore(app);