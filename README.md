<div align="center">

<h1> Raid Organizer </h1>

**Tool to Find, Coordinate and Schedule Statics inside a Community.**

<br>

[![Java](https://img.shields.io/badge/Java-Backend-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![Flutter](https://img.shields.io/badge/Flutter-Client%20%28deprecated%29-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![License](https://img.shields.io/github/license/mitaku-dev/raid-organizer?style=for-the-badge)](https://github.com/mitaku-dev/raid-organizer/blob/develop/LICENSE)

<br>

[Features](#-features) · [Architecture](#-architecture) · [Getting Started](#-getting-started) · [Project Status](#-project-status) · [Contributing](#-contributing)

<br><br>


</div>

> [!NOTE]
> This  project is **not** under active development and may contain unfinished features or rough edges.The Frontend is deprecated and just quickly migrated to Flutter3, many feature are still missing or not working!

---

## ✨ Features

| Feature | Description |
|---|---|
| 🗓️ **Raid Scheduling** | Create and manage raid events with dates, times, and sign-up slots |
| 👥 **Static Management** | Organise players into statics with defined roles and compositions |
| 🔍 **PF Matching** | Coordinate with raid-interested players outside of dedicated statics |
| 📋 **Role Overview** | Track Tank / Healer / DPS availability across your community |


---

## 🏗️ Architecture

This project is split into two parts:

```
raid-organizer/
├── server/   ← Java backend (REST API)
└── client/   ← Flutter frontend (deprecated, not functional)
```

### Server

The backend is written in **Spring Boot** and exposes a REST API for managing raids, statics, and players as well as handling Authentification.

### Client

> [!WARNING]
> The Flutter frontend located in `/client` is **deprecated and not in a working state**. Do not expect it to compile or run correctly.

---

## 🚀 Getting Started

### Prerequisites

- Java **17+**
- Gradle

### Running the server

```bash
# Clone the repository
git clone https://github.com/mitaku-dev/raid-organizer.git
cd raid-organizer

# Build and run the server
cd server
./gradlew bootRun
```

The API will be available at `http://localhost:8080` by default.

---

## 📌 Project Status


| Component | Status |
|---|---|
| Java backend | ✅ Functional |
| Flutter client | ❌ Deprecated — not in a working state |
| Active development | ⛔ None |

---


## 📄 License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for more information.

---

