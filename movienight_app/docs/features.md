# Features and Technical Specifications — MovieNight

**Course:** Computação Móvel (CM)  
**Academic Year:** 2025/2026  
**Team Identifier:** G02  
**Team Members:**
- 109222 – Gustavo Gião – gustavogiao@ua.pt
- 118313 – Solomiia Koba – solomiia.koba@ua.pt

---

## 1. Feature Implementation Matrix

| Feature Identifier | Feature Name | Primary Mobile Sensors / Tech | Implementation Status | Milestone |
|---|---|---|---|---|
| **FEAT-01** | Decoupled Session Orchestration & QR Sharing | Camera, QR Code, Flash Storage | **[DONE]** | Milestone 1 |
| **FEAT-02** | TMDb Ingestion & Resilient Offline Caching | TMDb REST API v3, HTTP, Local Flash Cache | **[DONE]** | Milestone 2 |
| **FEAT-03** | BLE Proximity Detection & Data Synchronization | Bluetooth Low Energy (GATT Peripheral/Central) | **[DONE]** | Milestone 2 |
| **FEAT-04** | Tilt Gesture Voting Engine | 3-Axis Accelerometer, IMU, Haptics | **[DONE]** | Milestone 2 |
| **FEAT-05** | Gyroscope-Powered Tie-Breaker Roulette | Rate Gyroscope (Z-Axis angular velocity) | **[PLANNED]** | Milestone 3 |
| **FEAT-06** | Augmented Reality Winner Reveal & Plane Anchoring | Camera, SLAM Plane Detection (ARCore/ARKit) | **[PLANNED]** | Milestone 3 |
| **FEAT-07** | Adaptive Dynamic UI (Light/Dark, i18n) | Dual Theme ColorScheme, Internationalization | **[DONE]** | Milestone 1 |

---

## 2. Feature Catalog

### 2.1 Feature 1: Decoupled Session Orchestration & QR Sharing
**Status:** [DONE]  
- **Description:** Enables any user to become an ad-hoc session host. The organizer defines the room's parameters without creating an online account or registering with a cloud server.
- **Implemented User Flow:**
  1. The user taps "Nova Sessão" on the home dashboard.
  2. Enters a memorable session title (e.g., "Friday Movie Night").
  3. The system generates an ephemeral session ID and encodes the room metadata into a compact JSON schema.
  4. A high-contrast QR code is rendered on screen alongside an alphanumeric session code.
  5. Nearby friends scan the QR code to join immediately.
- **Mobile Hardware Utilized:** High-density display rendering, cryptographic pseudo-random UUID generator.
- **Fallback / Resilience:** If the QR code cannot be optically scanned (e.g., damaged camera or poor lighting), users can connect via Bluetooth auto-discovery or by entering the alphanumeric session code.

---

### 2.2 Feature 2: TMDb Remote Ingestion & Resilient Offline Caching
**Status:** [DONE]  
- **Description:** Integrates with The Movie Database (TMDb) API to retrieve high-resolution posters, synopsis overviews, release years, runtimes, and user ratings based on user-defined filters.
- **Implemented Filtering Parameters:**
  - **Genres:** Multi-selection across standard cinema genres (Action, Drama, Comedy, Sci-Fi, Horror, Animation, etc.) mapped directly to TMDb genre IDs.
  - **Release Window:** Dual-bound year range inputs (`primary_release_date.gte` / `primary_release_date.lte`).
  - **Duration Boundary:** Slider selection from 60 minutes up to 240 minutes (`with_runtime.lte`).
  - **Minimum Rating Threshold:** Floating-point slider specifying minimum TMDb community score (`vote_average.gte`).
  - **Streaming Provider Availability:** Multi-selection filter tailored to regional subscription services in Portugal (`watch_region=PT`).
- **Offline Resilience & Data Persistence:**
  - Remote movie queries are fetched via `TmdbApiClient` and automatically serialized to local device storage (`MovieLocalDataSource`).
  - When disconnected or in airplane mode, the application gracefully falls back to local cache or bundled fallback models, ensuring the session proceeds without interruption.

---

### 2.3 Feature 3: Bluetooth Low Energy (BLE) Peer Detection & Data Sync
**Status:** [DONE]  
- **Description:** Establishes an ad-hoc, localized mesh network among participant devices without requiring internet access, Wi-Fi routers, or local network pairing PINs.
- **Technical Operation:**
  - **Host (Peripheral Mode):** Advertises a custom MovieNight GATT service UUID (`00000001-0000-1000-8000-00805F9B34FB`) and hosts read/write/notify characteristics.
  - **Participants (Central Mode):** Scan for advertising packets matching the MovieNight service UUID, connect to the GATT server, and establish a bidirectional binary data pipeline.
  - **Payload Handling:** JSON payloads are compressed, chunked (respecting GATT MTU limits), and transmitted over characteristic notifications.
  - **Synchronization:** Propagates `join_session` handshakes, `voting_started` movie catalogs, and `vote_cast` real-time events. Missing votes are synchronized via idempotent replay requests (`request_votes`).

---

### 2.4 Feature 4: Tilt Gesture Voting Engine (Inertial Sensors)
**Status:** [DONE]  
- **Description:** Replaces conventional on-screen button tapping with physical device manipulation. Users cast votes by physically tilting their smartphones.
- **Mechanics:**
  - **Like (Affirmative Vote):** The user tilts the device to the right. The on-screen movie card rotates clockwise, translates rightward, and displays a prominent green affirmative overlay before committing.
  - **Skip (Negative Vote):** The user tilts the device to the left. The card rotates counter-clockwise, translates leftward, and displays a red negative overlay before dismissing.
  - **Visual & Haptic Responsiveness:** Real-time affine transformations (`Matrix4`) track the phone's physical angle at 60 frames per second. Short haptic feedback pulses fire when the tilt passes the commitment threshold ($3.5\,\text{m/s}^2$).
- **Accessibility & Tactile Fallback:** Two dedicated tactile buttons ("Skip" and "Like") remain available at the base of the viewport for users unable to use gesture inputs.

---

### 2.5 Feature 5: Gyroscope-Powered Tie-Breaker Roulette
**Status:** [PLANNED]  
- **Description:** In the event of a tie among top-voted movies, the application initiates an interactive group roulette to break the deadlock in a transparent, engaging manner.
- **Sensor Integration:**
  - Utilizes the device's rate gyroscope to measure angular rotation around the vertical Z-axis ($\omega_z$).
  - Physical spinning of the smartphone by any group member imparts angular momentum to the virtual roulette wheel.
  - The wheel smoothly decelerates using realistic rotational friction simulation ($\mu = 0.985$), coming to rest on the definitive winning movie.
- **Fallback:** A manual swipe-to-spin gesture is supported if gyroscope hardware is unavailable.

---

### 2.6 Feature 6: Augmented Reality (AR) Winner Reveal & Plane Anchoring
**Status:** [PLANNED]  
- **Description:** Concludes the movie selection session with a shared visual spectacle by anchoring the winning movie's virtual 3D poster directly onto a physical surface in the room (such as a coffee table or floor).
- **Operation:**
  - The device camera feed is analyzed in real time using platform AR engines (ARCore on Android, ARKit on iOS).
  - Feature points are tracked to detect horizontal planes.
  - A visual reticle guides the user to tap on an identified planar surface.
  - Once placed, a 3D virtual pedestal and poster showcase are anchored in spatial coordinates, allowing participants to walk around and view the trophy from multiple angles.
- **Contingency Mode:** If the mobile hardware lacks ARCore/ARKit capabilities or plane detection cannot resolve under poor lighting, the application gracefully switches to an animated 2D camera viewport overlay, superimposing the celebratory poster directly onto the live camera stream.

---

### 2.7 Feature 7: Adaptive Dynamic UI (Light & Dark Modes, i18n Localization)
**Status:** [DONE]  
- **Description:** A polished visual presentation system supporting diverse user contexts, ambient lighting conditions, and languages.
- **Theme Adaptability:**
  - **Dark Mode:** Deep purple (`#0D0B1E`) and rich violet-black surfaces with cyan highlights, paired with soft particle visualizers for home cinema environments.
  - **Light Mode:** High-contrast slate backgrounds (`#F8FAFC`), crisp white containers, and deep violet typographic accents (`#0F172A`) ensuring readability in daylight.
  - **Instantaneous Transition:** Transitions occur with zero interpolation latency (`Duration.zero`), eliminating Flutter text style interpolation conflicts.
- **Internationalization (i18n):** Complete localized string catalogs in Portuguese (`pt`) and English (`en`), respecting device defaults or user-selected settings.

---

## 3. Sensor and Hardware Mapping

| Sensor / Hardware Component | Direct Responsibility | Feature Context | Status |
|---|---|---|---|
| **Camera & Image Stream** | Optical QR code detection and real-time environment video capture | `ScanSessionPage`, `ARPosterPage` | [DONE] (QR) / [PLANNED] (AR) |
| **Accelerometer** | Measuring lateral gravitational tilt ($A_x$) | `VotingPage` (Tinder-style gesture voting) | [DONE] |
| **Rate Gyroscope** | Measuring angular velocity ($\omega_z$) during device rotation | `RoulettePage` (Tie-breaker spinning) | [PLANNED] |
| **Bluetooth Chipset (BLE)** | Advertising (Peripheral GATT) and scanning/client connection (Central) | `SessionLobbyPage`, `BluetoothTestPage` | [DONE] |
| **Haptic Actuator (Vibrator)** | Tactile feedback pulses confirming vote commitment | `VotingPage` | [DONE] |
| **Flash Storage (NAND)** | Persisting session state, movie caches, and anonymous identity | SharedPreferences, Local Repository | [DONE] |

---

## 4. Technical Challenges and Contingency Strategies

### 4.1 Challenge 1: Augmented Reality Reliability Across Diverse Hardware
- **Risk:** Flutter AR integration packages (e.g., `ar_flutter_plugin`, `arkit_flutter_plugin`) exhibit fragmentation across Android vendor implementations, camera sensor calibrations, and ARCore compatibility levels. Certain budget devices lack hardware-accelerated Depth APIs.
- **Contingency Strategy:**
  1. The application executes a capability check during initialization (`isArSupported()`).
  2. If ARCore/ARKit is available, planar SLAM tracking is enabled.
  3. If unavailable, or if plane detection times out after 10 seconds, the UI gracefully switches to **Camera Viewport Overlay Mode**, rendering a celebratory 3D-perspective poster billboard over the live camera feed without requiring plane anchoring.

### 4.2 Challenge 2: Bluetooth Low Energy GATT Stability & Cross-Platform Permissions
- **Risk:** Modern mobile operating systems (especially Android 12+ and iOS 14+) enforce stringent runtime permissions for Bluetooth advertising and scanning (including location and nearby devices permissions). Furthermore, some budget chipsets restrict simultaneous peripheral advertising and central scanning.
- **Contingency Strategy:**
  1. Strict role separation: the session creator operates as the GATT Peripheral (advertiser), while participants operate strictly as GATT Centrals (scanners).
  2. The primary joining mechanism is dual-channel: the QR code contains the full session payload so that even if BLE advertising is delayed, peers immediately obtain the entire movie list and configuration optically.
  3. Payload fragmentation: large movie catalogs are indexed by TMDb IDs rather than raw strings, minimizing BLE transmission sizes below 512-byte MTU limits.

### 4.3 Challenge 3: Balancing Advanced Sensor Features with Core Usability
- **Risk:** Overburdening the user with complex sensor rituals can distract from the application's fundamental objective: helping friends quickly choose a movie.
- **Contingency Strategy:**
  - Every physical gesture interaction (tilt voting, phone spinning, AR reveal) has an immediate on-screen button alternative.
  - The voting cards accept standard screen swipe gestures and button taps alongside physical tilting.
  - The tie-breaker roulette accepts a direct screen tap to spin alongside physical rotation.
