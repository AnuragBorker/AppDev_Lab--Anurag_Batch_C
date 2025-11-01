import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from "react-native";
import { createUserWithEmailAndPassword } from "firebase/auth";
import { auth } from "../firebaseConfig";

export default function RegisterScreen({ navigation }) {
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");

    const handleRegister = async () => {
        try {
            await createUserWithEmailAndPassword(auth, email, password);
            Alert.alert("Account created successfully!");
        } catch (error) {
            Alert.alert("Registration Error", error.message);
        }
    };

    return (
        <View style={styles.container}>
            <Text style={styles.title}>Create Account 📝</Text>
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
            <TouchableOpacity style={styles.button} onPress={handleRegister}>
                <Text style={styles.buttonText}>Register</Text>
            </TouchableOpacity>

            <TouchableOpacity onPress={() => navigation.navigate("Login")}>
                <Text style={styles.link}>Already have an account? Login</Text>
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
    link: { marginTop: 20, textAlign: "center", color: "#007bff" },
});
