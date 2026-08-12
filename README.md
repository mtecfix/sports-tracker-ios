# Sports Tracker iOS

Niche sports session and gear tracker for surfers, climbers, golfers, and other passionate athletes.

## Features
- **Session Logger** — log sport, location, duration, rating, and conditions
- **Environmental Data** — record wave height, wind speed, and conditions per session
- **Gear Tracker** — track equipment wear and session count per item
- **Star Ratings** — 1-5 star rating for every session
- **Stats Dashboard** — total sessions, average rating, gear count, breakdown by sport

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
| POST | `/sessions` | Log a new session |
| GET | `/gear` | List all gear |
| POST | `/gear` | Add a gear item |
| GET | `/photo-upload` | Get presigned S3 URL for milestone photos |

## Project Structure
```
SportsApp/
├── Config.swift                  — API endpoints, Cognito IDs
├── SportsApp.swift               — App entry point
├── Models/
│   ├── Session.swift             — SportSession model + CreateSessionRequest
│   └── Gear.swift                — GearItem model + CreateGearRequest
├── Services/
│   └── APIService.swift          — All HTTP calls
├── ViewModels/
│   └── SportsViewModel.swift     — Sessions + gear state, stats
└── Views/
    ├── ContentView.swift         — Auth gate + tab navigation
    ├── SessionsView.swift        — Sessions list
    ├── LogSessionView.swift      — Log session form with star rating
    ├── GearView.swift            — Gear list
    ├── AddGearView.swift         — Add gear form
    ├── StatsView.swift           — Stats dashboard
    ├── LoginView.swift           — Sign in
    ├── SignUpView.swift          — Create account
    ├── ConfirmEmailView.swift    — Email verification
    └── ForgotPasswordView.swift  — Password reset
```

## Supported Sports
surfing, climbing, golf, windsurfing, cycling, snowboarding — easily extendable

## Getting Started
1. Open `Package.swift` in Xcode 15+
2. Build and run on iOS 16+ simulator or device
3. Sign in or create an account
4. Log your first session

## CI/CD
GitHub Actions builds automatically on every push to `main` using macOS runner.

## Installing via AltStore
1. Download the `.ipa` from the latest GitHub Actions build artifact
2. Open AltStore on your iPhone → tap `+` → select the `.ipa`
