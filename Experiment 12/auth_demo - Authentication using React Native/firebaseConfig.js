// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider } from "firebase/auth";
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyAbxwtDOcmejmYKtPB9s5iWcSKb7jEo63w",
    authDomain: "authflow-17f99.firebaseapp.com",
    projectId: "authflow-17f99",
    storageBucket: "authflow-17f99.firebasestorage.app",
    messagingSenderId: "30038401477",
    appId: "1:30038401477:web:4a652f080136749686ebac"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();