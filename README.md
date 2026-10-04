# MovieNight — Collaborative In-Person Movie Decision App

**Course:** Computação Móvel (CM)  
**Academic Year:** 2025/2026  
**Team Identifier:** G02  
**Team Members:**
- 109222 – Gustavo Gião – gustavogiao@ua.pt
- 118313 – Solomiia Koba – solomiia.koba@ua.pt

---

## 1. Project Context and Purpose

MovieNight is a mobile application developed for groups of friends physically gathered in the same location (at home, a cafe, or a lounge) who need to democratically and quickly decide which movie to watch. Instead of informal, indecisive verbal discussions or disorganized messaging polls, the application organizes the decision as an interactive, collaborative session across multiple devices in the same physical space, without relying on a dedicated online backend.

### Core Objectives
- Allow a session organizer (host) to configure voting preferences (genres, release year window, runtime limits, streaming providers).
- Retrieve movie suggestions via an external API (The Movie Database — TMDb), persisting data locally to ensure session continuity even without active internet connectivity.
- Invite nearby participants via a QR code encoding full session parameters, eliminating user accounts, logins, or online credentials.
- Enable independent, physical gesture voting (tilting the phone via accelerometer and gyroscope) alongside tactile fallback buttons.
- Automatically detect nearby peer devices via Bluetooth Low Energy (BLE), allowing seamless joining and vote exchange without central servers.
- Resolve vote ties using an interactive roulette whose angular momentum is controlled by physically rotating the phone (gyroscope).
- Reveal the winning title through an Augmented Reality (AR) showcase where the winning poster is anchored onto a physical table surface.
- Ensure that all session orchestration, consensus logic, and data persistence remain completely decoupled and offline-first.

---

## 2. Technical Documentation

Detailed technical documentation is available in the `/docs` directory:

- **[Requirements Specification (`docs/requirements.md`)](docs/requirements.md):** Complete catalog of Functional Requirements (FR-01 to FR-24), Non-Functional Requirements (NFR-01 to NFR-14), user personas, and hardware capability mapping.
- **[Architectural Design Document (`docs/architecture.md`)](docs/architecture.md):** Clean Architecture breakdown, Riverpod reactive state flow, peer-to-peer BLE star-mesh topology, mathematical IMU sensor pipeline, and sequence diagrams.
- **[Features & Sensor Specifications (`docs/features.md`)](docs/features.md):** Exhaustive breakdown of all 7 core features, mobile hardware roles, user journeys, accessibility considerations, and contingency strategies.

---

## 3. Mobile Sensors & Hardware Capabilities

| Capability / Sensor | Technical Application in MovieNight | Fallback Mode |
|---|---|---|
| **Camera & QR Scanner** | Instant session joining by decoding JSON payload from host screen. | Bluetooth auto-discovery or alphanumeric code input. |
| **Accelerometer** | Physical tilt gesture voting (tilt right for Like, tilt left for Skip). | On-screen tactile buttons. |
| **Rate Gyroscope** | Physical device rotation imparting momentum to the tie-breaker roulette. | Manual swipe-to-spin gesture. |
| **Bluetooth Low Energy (BLE)** | Ad-hoc peer discovery (GATT Peripheral/Central) and real-time vote synchronization. | QR optical configuration and local calculation. |
| **Augmented Reality (ARCore/ARKit)** | Planar surface detection and 3D spatial anchoring of the winning movie poster. | Animated 2D camera viewport overlay. |
| **Connectivity & Cache** | Online/offline detection with transparent fallback to local movie cache. | Fully air-gapped operation using pre-cached catalogs. |

---

## 4. Architecture Summary

MovieNight is built on Flutter using strict Clean Architecture layers:
- **Presentation Layer:** Flutter UI with declarative Riverpod state controllers and dynamic dual-theme support (Full Light and Dark modes).
- **Domain Layer:** Pure Dart business logic and immutable aggregate roots (`Session`, `Movie`, `Vote`, `VotingSession`).
- **Data Layer:** TMDb REST API client, local flash persistence, and low-level hardware drivers (IMU streams, Bluetooth services, Camera controller).

All consensus logic is decentralized: the host acts as an ad-hoc BLE peripheral relay, and every device independently validates and tallies votes using an idempotent state aggregate root.

---

## 5. Main Engineering Challenges & Contingency Strategy

1. **Augmented Reality Stability Across Devices:** ARCore and ARKit package stability varies significantly across mobile chipsets. The application incorporates a runtime compatibility check that automatically falls back to an interactive camera overlay if planar SLAM tracking is unavailable.
2. **Bluetooth Cross-Platform Handshakes:** To navigate Android/iOS BLE permission differences and background limitations, the host acts exclusively as a GATT Peripheral (advertiser), while participants act as Centrals (scanners). Optical QR scanning serves as an immediate zero-latency backup.
3. **Ergonomic Balance:** All physical sensor interactions (tilt voting, phone spinning) are paired with intuitive on-screen button controls to guarantee accessibility and convenience across all usage environments.

---

## 6. Project Structure

```text
CM-project/
├── docs/
│   ├── architecture.md           # Clean architecture, BLE topology & diagrams
│   ├── features.md               # Detailed feature specifications & sensor mappings
│   └── requirements.md           # Functional and non-functional requirements
├── movienight_app/
│   ├── lib/
│   │   ├── app/                  # App setup, theme definitions, navigation root
│   │   ├── core/                 # Bluetooth, permissions, low-level services
│   │   ├── features/
│   │   │   ├── movies/           # TMDb client, models, filtering, movie cards
│   │   │   ├── session/          # Session creation, lobby, QR generation/scanning
│   │   │   ├── settings/         # Theme toggling, language switcher
│   │   │   └── voting/           # IMU tilt voting, state notifier, results
│   │   ├── l10n/                 # Localization (pt, en)
│   │   └── shared/               # Reusable widgets, providers, identity service
│   └── pubspec.yaml
└── README.md
```