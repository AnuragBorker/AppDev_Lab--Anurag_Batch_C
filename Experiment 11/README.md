# 🌍 Application of Weather API

A simple **Flutter application** that fetches and displays real-time weather data (temperature) for any city using the **Open-Meteo API** — a free and keyless weather data provider.

---

## 📱 Overview

This app allows the user to:
- Enter a **city name**
- Fetch **latitude and longitude** using the Open-Meteo **Geocoding API**
- Retrieve the **current temperature** using the Open-Meteo **Weather Forecast API**
- Display the weather data neatly in the UI

It’s a lightweight example of using a **REST API** in Flutter, perfect for students or beginners learning API integration.

---

## ✨ Features

- 🌆 Search by any city name  
- ☀️ Displays real-time temperature in °C  
- ⚡ Uses Open-Meteo’s **free APIs** (no API key needed)  
- 📡 Demonstrates how to call REST APIs using Dart’s `http` package  
- 🧭 Converts city name → latitude & longitude automatically  
- 🧩 Clean and minimal UI  

---

## 🧠 How It Works

1. User enters a **city name** in the text field.  
2. App calls the **Geocoding API** to get coordinates:
3. App extracts the latitude and longitude from the response.  
4. It then calls the **Weather API**:
5. Displays the **current temperature** in the app.

---

## 🧩 Tech Stack

| Component | Technology |
|------------|-------------|
| Frontend | Flutter |
| Language | Dart |
| Networking | HTTP package |
| API Provider | [Open-Meteo](https://open-meteo.com/) |
| Data Format | JSON |

---
