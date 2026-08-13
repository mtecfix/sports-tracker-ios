# Sports Tracker iOS
> Niche sports session and gear tracker for surfers, climbers, golfers, and other passionate athletes.

[![Build](https://github.com/mtecfix/sports-tracker-ios/actions/workflows/build.yml/badge.svg)](https://github.com/mtecfix/sports-tracker-ios/actions)
![Swift](https://img.shields.io/badge/Swift-5.9-orange)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue)

---

## Features
- **Session Logger** — sport, location, duration, star rating, conditions
- **Environmental Data** — wave height, wind speed, conditions per session
- **Gear Tracker** — track equipment by brand/type, auto-increments session count
- **Edit/Delete** — full CRUD on sessions and gear
- **Photo Upload** — presigned S3 URL for milestone photos
- **Charts** — sessions by month, rating trend (last 10), sport breakdown, top gear
- **Stats Dashboard** — total sessions, average rating, gear count
- **Offline Mode** — sessions and gear cached locally
- **Full Auth Flow** — sign up, email verification, forgot password, sign in

## AWS Backend
| Resource | Value |
|----------|-------|
| API Endpoint | `https://i2i5aq78u1.execute-api.us-east-1.amazonaws.com/dev` |
| Cognito Pool | `us-east-1_9LQYVOUIJ` |
| Cognito Client | `o7rpn3nvfe3iu2hm0e2li1qdk` |
| DynamoDB (Sessions) | `sports-primary` |
| DynamoDB (Gear) | `sports-secondary` |
| S3 Bucket | `sports-663877906756` |
| Lambda | `sports-api` (Node.js 20) |

## API Routes
| Method | Route | Description |
|--------|-------|-------------|
| GET | `/sessions` | List all sessions |
| POST | `/sessions` | Log session (auto-increments gear count) |
| DELETE | `/sessions/{id}` | Delete session |
| GET | `/gear` | List all gear |
| POST | `/gear` | Add gear item |
| PUT | `/gear/{id}` | Update gear |
| DELETE | `/gear/{id}` | Delete gear |
| GET | `/photo-upload` | Presigned S3 URL for photo |

## Project Structure
```
SportsApp/
├── Assets.xcassets/              ← App icon (placeholder — replace AppIcon-1024.png)
├── Config.swift
├── SportsApp.swift               ← App entry + launch screen animation
├── Models/
│   ├── Session.swift
│   └── Gear.swift
├── Services/
│   ├── APIService.swift
│   ├── AuthService.swift
│   ├── LocalCache.swift
│   ├── NotificationManager.swift
│   └── OfflineBanner.swift
├── ViewModels/
│   └── SportsViewModel.swift     ← Full CRUD + gear session count + offline cache
└── Views/
    ├── LaunchScreenView.swift    ← Ocean blue gradient + surfing figure
    ├── ContentView.swift         ← 4 tabs: Sessions, Gear, Charts, Stats
    ├── LoginView.swift
    ├── SignUpView.swift
    ├── ConfirmEmailView.swift
    ├── ForgotPasswordView.swift
    ├── SessionsView.swift        ← Sessions list with star ratings
    ├── SessionDetailView.swift   ← Full session detail + gear used + delete
    ├── LogSessionView.swift      ← Log form with star rating picker
    ├── GearView.swift
    ├── GearDetailView.swift      ← Gear info + sessions used + edit/delete
    ├── AddGearView.swift
    ├── EditGearView.swift        ← Update gear with condition picker
    ├── SportsChartsView.swift    ← Bar charts + rating trend + sport breakdown
    └── StatsView.swift           ← Summary stats
```

## Supported Sports
surfing · climbing · golf · windsurfing · cycling · snowboarding — easily extendable in `LogSessionView`

## App Icon
Placeholder: `SportsApp/Assets.xcassets/AppIcon.appiconset/AppIcon-1024.png` (solid ocean blue).
Replace with your 1024×1024 PNG.

## Launch Screen
Ocean blue gradient with surfing figure, fades out after 1.8s.

## Installing via AltStore
1. Download `.ipa` from GitHub Actions build artifacts
2. Open AltStore → tap `+` → select `.ipa`

## CI/CD
GitHub Actions builds on every push to `main` using macOS runner.
