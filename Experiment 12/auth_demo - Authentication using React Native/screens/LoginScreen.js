import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from "react-native";
import { signInWithEmailAndPassword, signInWithCredential, GoogleAuthProvider } from "firebase/auth";
import * as WebBrowser from "expo-web-browser";
import * as Google from "expo-auth-session/providers/google";
import { auth } from "../firebaseConfig";

WebBrowser.maybeCompleteAuthSession();

export default function LoginScreen({ navigation }) {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    const [request, response, promptAsync] = Google.useAuthRequest({
        webClientId: "30038401477-oobadjh3uflhnu5dgord785av8sh7e7c.apps.googleusercontent.com",
        expoClientId: "30038401477-oobadjh3uflhnu5dgord785av8sh7e7c.apps.googleusercontent.com",
        androidClientId: "30038401477-jf333o7h6gmhjvqema671pb7nst598vr.apps.googleusercontent.com"
    });

    const handleLogin = async () => {
        try {
            await signInWithEmailAndPassword(auth, email, password);
        } catch (error) {
            Alert.alert("Login Error", error.message);
        }
    };

    const handleGoogleLogin = async () => {
        try {
            const result = await promptAsync();
            if (result?.type === "success") {
                const { id_token } = result.params;
                const credential = GoogleAuthProvider.credential(id_token);
                await signInWithCredential(auth, credential);
            }
        } catch (error) {
            Alert.alert("Google Sign-In Error", error.message);
        }
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Welcome Back 👋</Text>

            <TextInput
                placeholder="Email"
                value={email}
                onChangeText={setEmail}
                style={styles.input}
            />

            <TextInput
                placeholder="Password"
                secureTextEntry
                value={password}
                onChangeText={setPassword}
                style={styles.input}
            />

            <TouchableOpacity style={styles.button} onPress={handleLogin}>
                <Text style={styles.buttonText}>Login</Text>
            </TouchableOpacity>

            <TouchableOpacity style={styles.googleButton} onPress={handleGoogleLogin}>
                <Text style={styles.googleText}>Sign in with Google</Text>
            </TouchableOpacity>

            <TouchableOpacity onPress={() => navigation.navigate("Register")}>
                <Text style={styles.link}>Don't have an account? Register</Text>
            </TouchableOpacity>
        </View>
    );
}

const styles = StyleSheet.create({
    container: { flex: 1, justifyContent: "center", padding: 25, backgroundColor: "#fff" },
    title: { fontSize: 28, fontWeight: "bold", textAlign: "center", marginBottom: 30 },
    input: { borderWidth: 1, borderColor: "#ccc", borderRadius: 8, padding: 12, marginBottom: 15 },
    button: { backgroundColor: "#007bff", padding: 15, borderRadius: 8 },
    buttonText: { color: "#fff", textAlign: "center", fontWeight: "bold" },
    googleButton: { backgroundColor: "#fff", borderWidth: 1, borderColor: "#ccc", padding: 15, borderRadius: 8, marginTop: 10 },
    googleText: { textAlign: "center", color: "#333" },
    link: { marginTop: 20, textAlign: "center", color: "#007bff" },
});
