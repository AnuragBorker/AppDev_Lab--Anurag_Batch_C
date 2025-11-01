package com.example.authdemokotlin

import android.app.Application
import com.google.firebase.FirebaseApp
import com.google.firebase.auth.FirebaseAuth

object FirebaseModule {
    fun getAuth(): FirebaseAuth {
        return FirebaseAuth.getInstance()
    }
}
