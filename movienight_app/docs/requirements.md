# Requirements Specification — MovieNight

**Course:** Computação Móvel (CM)  
**Team Identifier:** G02  
**Team Members:**
- 109222 – Gustavo Gião – gustavogiao@ua.pt
- 118313 – Solomiia Koba – solomiia.koba@ua.pt

---

## 1. Project Overview and Context

MovieNight is a mobile application tailored for groups of friends physically gathered in the same location (such as living rooms, cafes, or meeting spaces) who need to democratically and rapidly select a movie to watch. Instead of informal, indecisive verbal discussions or disorganized messaging polls, MovieNight turns the decision process into an interactive, synchronized session across multiple devices in proximity.

Crucially, the entire experience is architected without reliance on a dedicated cloud backend or central server infrastructure. Devices communicate in a peer-to-peer, decoupled topology using on-device mobile hardware, local persistence, and ad-hoc communication.

---

## 2. Stakeholders and Target Personas

### 2.1 Primary Stakeholders
- **Session Organizer (Host):** The individual who initiates the room, configures filtering parameters (genres, release year, streaming platforms), and coordinates the voting progression.
- **Session Participants (Peers):** Individuals who join the session via nearby detection or QR scanning and participate in gesture voting and tie-breaking.
- **Academic Evaluators:** Course instructors assessing mobile sensor integration, offline-first decoupled architecture, state management patterns, and system resilience.

### 2.2 Target User Personas
- **The Decisive Host:** Wants to set up movie parameters quickly without requiring anyone to register accounts, download auxiliary services, or type passwords.
- **The Casual Viewer:** Wants an intuitive, playful, and physical voting mechanic (e.g., tilting the phone) rather than tapping monotonous radio buttons.

---

## 3. Functional Requirements (FR)

### 3.1 Session Lifecycle and Configuration
- **FR-01 (Session Creation):** The host must be able to create a new session by specifying a session title.
- **FR-02 (Movie Preference Filters):** The host must be able to configure movie filtering criteria including:
  - Selected genres (multiple choice).
  - Release year range (minimum and maximum).
  - Maximum runtime duration (in minutes).
  - Minimum TMDb user rating threshold (0.0 to 10.0 scale).
  - Target streaming platforms available in the group's region.
- **FR-03 (Session Code & Payload Encoding):** The application must encode the session configuration, session ID, organizer ID, and timestamp into a standardized JSON payload.
- **FR-04 (QR Code Broadcast):** The host device must render a high-contrast QR code encoding the session payload for immediate visual ingestion by nearby peers.

### 3.2 Peer Discovery, Proximity and Joining
- **FR-05 (Optical Joining via QR):** Peer devices must be able to scan the host's QR code using the device camera to extract configuration and automatically join the session.
- **FR-06 (Bluetooth Low Energy Advertising):** The host device must advertise its presence over Bluetooth Low Energy (BLE) as a peripheral using a dedicated MovieNight GATT service UUID.
- **FR-07 (Bluetooth Low Energy Scanning):** Peer devices must be capable of scanning for nearby MovieNight BLE advertising packets and discovering active sessions without manual pairing.
- **FR-08 (Zero-Account Identity):** The application must generate and persist an anonymous, unique participant UUID locally on each device, eliminating third-party authentication dependencies (e.g., Google or Facebook OAuth).

### 3.3 Movie Retrieval and Local Persistence
- **FR-09 (External API Consumption):** The application must interface with The Movie Database (TMDb) REST API using an application-level API token to query titles, posters, release metadata, overviews, and ratings.
- **FR-10 (Decoupled Offline-First Storage):** All fetched movie datasets, session definitions, and user cast votes must be persisted in local storage (such as SharedPreferences and local database cache) to enable session continuity in air-gapped or disconnected environments.
- **FR-11 (Connectivity Awareness):** The application must continuously monitor network reachability. When offline, it must gracefully fall back to locally cached movie catalogs without blocking session creation or progression.

### 3.4 Physical & Gestural Voting Engine
- **FR-12 (Sequential Movie Card Stack):** The application must present the filtered movie candidate list as an interactive, sequential card deck.
- **FR-13 (Tilt-Based Voting via IMU):** The application must read accelerometer and gyroscope sensor streams to determine device tilt:
  - Tilting the phone to the right casts an affirmative vote ("Like").
  - Tilting the phone to the left casts a negative vote ("Skip").
- **FR-14 (Real-time Visual Feedback):** As the device is tilted, the card must rotate and translate dynamically, providing real-time color overlays (green for Like, red for Skip) matching the physical angle.
- **FR-15 (Tactile Input Fallback):** The interface must provide on-screen tap buttons for affirmative and negative votes to accommodate accessibility requirements and still/calibrated environments.
- **FR-16 (Decoupled Vote Exchange):** Cast votes must be propagated across participants via BLE peripheral/central data channels and aggregated locally on each node.

### 3.5 Tie-Breaking & Decision Finalization
- **FR-17 (Result Aggregation & Ranking):** The application must calculate vote tallies locally on each device and determine the ranking order of candidate movies.
- **FR-18 (Automatic Tie Detection):** When multiple movies tie for the first-place position, the system must trigger a tie-breaking sequence.
- **FR-19 (Gyroscope-Controlled Roulette):** The tie-breaker must render an interactive roulette containing only the tied candidates. The spin velocity and angular momentum of the roulette must be controlled by physically rotating the mobile device (measuring angular velocity through the gyroscope).

### 3.6 Augmented Reality (AR) Winner Reveal
- **FR-20 (Horizontal Plane Detection):** The application must utilize the device camera and AR engine (ARCore / ARKit) to identify physical horizontal surfaces (such as a table or floor).
- **FR-21 (Spatial Poster Anchoring):** Upon user tap on a detected plane, the winning movie's poster and title banner must be anchored in three-dimensional augmented space as a virtual collectible trophy.
- **FR-22 (AR Contingency Mode):** If the device hardware or OS lacks AR support, or plane detection fails to resolve, the app must provide an animated 2D camera viewport overlay revealing the winning poster over the real-world feed.

### 3.7 Personalization and System Configuration
- **FR-23 (Dynamic Theme Support):** The interface must provide instantaneous switching between a vibrant Dark Mode (deep purple/cyan) and an accessible Full Light Mode (slate/violet), guaranteeing high contrast across all elements.
- **FR-24 (Internationalization - i18n):** The system must support complete localization for Portuguese (pt) and English (en), dynamically reacting to locale changes without application restart.

---

## 4. Non-Functional Requirements (NFR)

### 4.1 Architecture and Decoupling
- **NFR-01 (Zero Dedicated Backend):** The system must not require, depend upon, or communicate with a custom central server, cloud database, or Firebase instance. All coordination logic must run distributed on user devices.
- **NFR-02 (Layered Separation of Concerns):** The codebase must strictly adhere to Clean Architecture principles, ensuring complete decoupling between Presentation (UI/Widgets), Domain (Entities/Use Cases), and Data (Repositories/Data Sources).
- **NFR-03 (Declarative State Management):** State mutation and dependency injection must be managed through Flutter Riverpod, guaranteeing predictable rebuild lifecycles and zero global state leakage.

### 4.2 Performance and Latency
- **NFR-04 (Sensor Sampling Frequency):** Accelerometer and gyroscope data streams must be throttled to 50–60 Hz to ensure fluid animation response (60 fps) without inducing CPU thermal throttling or battery drain.
- **NFR-05 (BLE Packet Processing):** Incoming Bluetooth Low Energy message payloads must be processed, decoded, and reflected in the local state in less than 200 ms.
- **NFR-06 (Theme Switch Latency):** Switching between Light and Dark visual modes must complete instantaneously (0 ms animation duration) to eliminate frame interpolation overhead and render tree crashes.

### 4.3 Usability, Accessibility, and Ergonomics
- **NFR-07 (One-Handed Usability):** Critical interactive elements (voting buttons, swipe zones, navigation actions) must reside within comfortable thumb reach of mobile viewports.
- **NFR-08 (Legibility & WCAG Compliance):** All textual elements across both Light and Dark themes must satisfy WCAG 2.1 Level AA contrast ratios (minimum 4.5:1 for normal text, 3:1 for large text).
- **NFR-09 (Zero Onboarding Friction):** A participant must be able to join an ongoing session within 5 seconds of opening the application, without entering user credentials or pairing PINs.

### 4.4 Reliability, Fault Tolerance, and Robustness
- **NFR-10 (Graceful Offline Degradation):** When no internet connection is present, all features excluding initial TMDb catalog fetching must remain completely functional using pre-cached data.
- **NFR-11 (Connection Drop Resilience):** If a peer loses Bluetooth connectivity during voting, the host and other peers must continue voting unabated. Upon reconnection, missing votes must synchronize via idempotent replay.
- **NFR-12 (Malformation Protection):** QR codes or BLE packets with invalid schemas or mismatched session IDs must be discarded silently without crashing the application runtime.

### 4.5 Security and Privacy
- **NFR-13 (Zero PII Collection):** The application must not collect, store, or transmit Personally Identifiable Information (names, emails, phone numbers, location coordinates).
- **NFR-14 (Ephemeral Session Scope):** Session tokens, transient peer connections, and vote tallies must exist only within the context of the physical event and be cleanable from local storage.

---

## 5. Hardware Capabilities & Sensor Mapping Matrix

| Mobile Capability / Sensor | Application Feature | Purpose / Mechanism | Fallback Mode |
|---|---|---|---|
| **Camera & QR Scanner** | Session Joining (`ScanSessionPage`) | Rapid peer onboarding by reading encoded JSON session configurations. | Manual session code input or BLE auto-discovery. |
| **Accelerometer** | Gestural Voting (`VotingPage`) | Measures lateral device tilt (`tiltX`) to trigger Like (right) or Skip (left) votes. | On-screen tactile buttons. |
| **Gyroscope** | Tie-Breaking Roulette (`RoulettePage`) | Converts rotational velocity into angular momentum for spinning the selection wheel. | Manual swipe-to-spin gesture. |
| **Bluetooth Low Energy (BLE)** | Peer Proximity & Session Sync | Ad-hoc discovery (advertising/scanning) and transmission of vote payloads. | Direct QR configuration and local tallying. |
| **AR Engine (Camera + SLAM)** | Winner Announcement (`ARPosterPage`) | Detects horizontal planes in physical space to anchor the winning poster. | 2D camera viewport overlay / animated showcase. |
| **Network Connectivity** | Movie Fetching (`TMDb API`) | Fetches rich movie metadata, posters, overviews, and ratings. | Embedded offline movie database cache. |
