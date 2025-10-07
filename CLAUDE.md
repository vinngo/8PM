# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

8PM is an iOS app built with SwiftUI that uses Supabase for backend services. The app appears to be a social accountability platform where users commit to daily tasks/goals and share proof of completion.

## Build and Test Commands

### Building
```bash
# Build the project (requires Xcode)
xcodebuild -project 8PM.xcodeproj -scheme 8PM -configuration Debug

# Or open in Xcode
open 8PM.xcodeproj
```

### Testing
```bash
# Run unit tests
xcodebuild test -project 8PM.xcodeproj -scheme 8PM -destination 'platform=iOS Simulator,name=iPhone 15'

# Run specific test target
xcodebuild test -project 8PM.xcodeproj -scheme 8PM -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:8PMTests

# Run UI tests
xcodebuild test -project 8PM.xcodeproj -scheme 8PM -destination 'platform=iOS Simulator,name=iPhone 15' -only-testing:8PMUITests
```

## Architecture

### Core Structure

The app follows an MVVM (Model-View-ViewModel) pattern with feature-based organization:

- **8PM/App/**: Application entry point and root view management
  - `_PMApp.swift`: Main app entry point, initializes Supabase connection
  - `RootView.swift`: Root view that handles authentication state and routing

- **8PM/Core/**: Feature modules organized by domain
  - **Authentication/**: Phone-based authentication flow
    - ViewModels: `AuthViewModel` handles phone verification logic
    - Views: Authentication UI components
  - **Daily/**: Daily task/goal management
  - **Feed/**: Social feed for viewing others' completed tasks
  - **Profile/**: User profile management
  - **Camera/**: Photo capture for task proof

- **8PM/Models/**: Data models matching Supabase schema
  - `User.swift`: User profile model with phone, display name, avatar, bio
  - `Daily.swift`: `DailyThing` model representing a daily commitment with proof tracking (photos, timestamps, completion status)

- **8PM/Services/**: Backend integration layer
  - `SupabaseService.swift`: Singleton service managing Supabase client instance and current user
  - `SupabaseConfig.swift`: Contains Supabase URL and API key (excluded from git)

### Key Architectural Patterns

1. **Supabase Integration**: All backend operations go through `SupabaseService.shared.client`
2. **@MainActor**: ViewModels and services are marked with `@MainActor` for thread safety with UI updates
3. **Authentication State**: Managed centrally in `RootView` using Supabase auth session
4. **Models**: Mirror Supabase database schema with snake_case to camelCase mapping via `CodingKeys`

### Data Flow

```
View → ViewModel (@Published) → SupabaseService → Supabase Client → Backend
                                        ↓
                                  Models (Codable)
```

## Important Notes


## User Flows

### Flow 1: First Time User (Onboarding)

1. Open app → Welcome screen
2. Tap "Continue" → Phone number entry
3. Enter phone → Receive SMS code
4. Enter verification code → Account created
5. Create profile (name)
6. 4-screen onboarding tutorial
7. Find friends (optional)
8. Set first daily thing
9. Home screen (empty feed state)

### Flow 2: Daily Morning Routine

1. 9:00 AM notification: "Set your thing for today"
2. Open app → "What's your ONE thing today?"
3. Type goal (e.g., "Go for a 20-min run")
4. Tap "Lock It In"
5. Confirmation: "Your thing is set. Do it by 8 PM."
6. Home screen shows: "⏳ Waiting for proof..."

### Flow 3: Taking Proof Photo

1. Complete your thing during the day
2. Open app → Tap "Take Proof Photo"
3. Grant camera permission (first time only)
4. Dual camera view opens (front + back)
5. Tap capture button → Both photos taken
6. Review screen → Choose "Retake" or "Use This"
7. If "Use This" → Photos locked
8. Confirmation: "🔒 Locked & Ready! Posting at 8:00 PM"
9. Home screen shows: "✅ Proof locked"

### Flow 4: 8 PM Drop (Completed)

1. 8:00 PM → Auto-post triggered
2. Locked photos upload to server
3. Push notification: "🔔 IT'S TIME! Your proof is now live"
4. Open app → Feed unlocks
5. See all friends' posts for today
6. React to posts with emojis
7. View profiles, follow new people

### Flow 5: 8 PM Drop (Didn't Complete)

1. 8:00 PM notification: "Did you do it yet?"
2. Open app → Prompt: "Did you do it?"
3. Tap "I Didn't 😔"
4. Dual camera opens: "Take a photo of where you are right now"
5. Capture honest photo
6. Optional: Select reason (dropdown)
7. Post marked ❌ "Didn't complete"
8. Feed unlocks → See friends' posts

### Flow 6: Missed 10 AM Deadline

1. Open app after 10:00 AM (no thing set)
2. Lockout screen: "You missed today's deadline"
3. Message: "Try again tomorrow at 9 AM"
4. Option: "See What Friends Are Doing" (read-only feed)
5. Cannot participate today
6. Marked as "⏳ No response" in friends' feeds

### Configuration
- `SupabaseConfig.swift` is gitignored and contains sensitive credentials
- The config requires `url` and `key` static properties
- Target deployment: iOS 18.5+
- Swift version: 5.0

### Dependencies
- **Supabase Swift SDK** (v2.5.1+): Installed via Swift Package Manager
  - Repository: https://github.com/supabase/supabase-swift
  - Used for authentication, database operations, and storage

### Current State
- The on-boarding tutorial is the next step in implementation. This happens once the user signs up for the first time.
- RootView shows placeholder text for authenticated/unauthenticated states
- Core feature modules (Camera, Daily, Feed, Profile) have folder structure but no implementations yet
