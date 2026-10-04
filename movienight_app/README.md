# G02 - MovieNight

**Team:**
* 109222 - Gustavo Giao - gustavogiao@ua.pt
* 118313 - Solomiia Koba - solomiia.koba@ua.pt

## Application Context

MovieNight is a mobile application designed for groups of friends gathering physically (at home, in a cafe, or a living room) who need to quickly and collaboratively decide on a movie to watch. Instead of the usual informal discussion or voting in a group chat, the app structures the decision as an interactive, collaborative session between multiple devices present in the same physical space, without relying on a dedicated online backend.

*Read this in [Portuguese](README.pt.md).*

---

## Application Purpose

* Allow an organizer to create a voting session by defining preferences (genres, release year, duration, and available streaming platforms).
* Fetch movie suggestions via the external TMDB API. Data is cached locally to allow the session to continue even without an active internet connection.
* Invite participants to the session via a QR code that encodes the session configuration. No online accounts or credentials are required.
* Automatically detect nearby devices via Bluetooth (BLE) to allow joining the session and exchanging votes without exclusively relying on manual QR code scanning.
* Allow independent voting using physical gestures (tilting the phone via accelerometer/gyroscope) instead of conventional touch interactions, making the experience more physical and suitable for a social context.
* In case of a tie between finalist movies, resolve it through an interactive roulette whose movement is controlled by the physical rotation of the phone (gyroscope), making the outcome visible and participatory for the whole group.
* Reveal the winning movie through an Augmented Reality moment: the movie poster is anchored to a real physical surface (e.g., the table) via the device's camera, creating a visual highlight at the end of the session.
* Ensure that all voting logic, result aggregation, and data persistence work completely offline without requiring a constant internet connection or a proprietary backend server.

---

## Sensors & Mobile Functionalities

* **Camera / QR Code:** Used for reading the session configuration and optionally anchoring the AR poster.
* **Accelerometer / Gyroscope:** Used for gestural voting (tilting the phone) and controlling the tie-breaker roulette.
* **Bluetooth (BLE):** Used for proximity detection among group devices and P2P data exchange (session data/votes) without a central server.
* **Augmented Reality (ARCore/ARKit):** Uses the camera and plane detection to reveal the winning movie as a 3D object anchored to a physical surface.
* **Connectivity-Awareness:** Detects online/offline states to adapt the app's behavior (using cached data when offline).

---

## External Systems

* **TMDB API:** External movie database used for fetching metadata (posters, synopsis, rating, genre, year). It does not require user authentication or personal credentials, fulfilling the requirement of avoiding login dependencies (e.g., Google/Facebook).

---

## Architecture

The project is built using **Flutter** and strictly follows **Clean Architecture** combined with a **Feature-First** approach.

### Architectural Layers (Per Feature)
* **Domain Layer:** Contains the core business rules (Entities, Use Cases, Repositories Interfaces).
* **Data Layer:** Handles data retrieval and storage (Models, Repositories Implementations, Data Sources like API clients or local databases).
* **Presentation Layer:** UI and state management (Pages, Widgets, Providers).

### State Management & Dependency Injection
* **Riverpod:** Used for predictable state management, dependency injection, and reactive UI updates.

### Core Modules
* **features/session:** Logic for creating, scanning (QR), and managing lobby participants.
* **features/movies:** TMDB API integration and local movie caching.
* **features/voting:** Gestural voting logic and tie-breaker roulette.
* **features/settings:** Theme (Light/Dark mode) and Language preferences.
* **core/bluetooth:** Low-level Bluetooth Low Energy (BLE) infrastructure for peer-to-peer communication.

---

## Main Challenge

From our perspective, the main challenge of the project is two-fold. 

Technically, implementing Augmented Reality reliably within the available timeframe. Plane detection and object anchoring in Flutter heavily depend on the device and the state of the AR package ecosystem. We plan to validate this functionality as early as possible, with a simpler contingency plan (overlaying the poster on the camera feed without spatial anchoring) if the full solution isn't stable in time. 

On the product side, the fundamental challenge is balance: combining several technically ambitious features (AR, Bluetooth, motion sensors) without compromising the robustness and simplicity of the core experience. Choosing a movie as a group remains the primary goal, and all advanced features must enhance this experience rather than overcomplicate it.

---

## Project Assessment Requirements

The following table details how the MovieNight project fulfills the specific evaluation criteria and technical requirements outlined in the course syllabus.

| Requirement                         | Value | Fulfillment Strategy                                                                                                                                                                                                                                        |
|:------------------------------------|:-----:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **4 mandatory elements**            |   2   | We incorporate multiple mandatory mobile elements: Bluetooth P2P communication, Camera/QR Code, Hardware Sensors (Accelerometer/Gyroscope), and Augmented Reality.                                                                                          |
| **Milestone 1 - storyboard**        |   2   | The application UI and navigation flow are already structured in Flutter and fully deployable as a standalone app on physical devices, without relying on an emulator.                                                                                      |
| **Milestone 2 - 2 features**        |   2   | We can demonstrate the capture and display of Accelerometer/Gyroscope data (for gestural voting/roulette) and the ability to scan and decode QR codes (for session invites) running natively on a device.                                                   |
| **Milestone 3 - Demo & doc.**       |   8   | The final solution will integrate all features seamlessly to solve the proposed problem (group movie selection) with complete documentation mapping out the Clean Architecture approach.                                                                    |
| **Using advanced state management** |   2   | We are utilizing **Riverpod** for robust, reactive state management and dependency injection across the entire application.                                                                                                                                 |
| **Support decoupled scenario**      |   1   | The app is strictly **Offline-First**. We do not use Firebase. Devices communicate peer-to-peer via Bluetooth, meaning the voting session works entirely offline in a decoupled scenario.                                                                   |
| **Data management solution**        |   1   | We use a Feature-First Clean Architecture with dedicated Repositories and Data Sources. Persistence is handled locally on the device (using SharedPreferences and local databases like Isar/SQLite) without Cloud synchronization platforms like Firestore. |
| **External sources/sensors**        |   2   | We utilize the **TMDB API** as an external data web source for movie metadata. Additionally, we use **device sensors** (Accelerometer, Gyroscope, Camera) extensively for the core mechanics of the app.                                                    |
