# Android Gatelog Overlay

> A guide for Flutter developers who don't know Android platform specifics.

## What is this?

The gatelog overlay is a floating UI that appears **on top of everything** — home screen, other apps, lock screen — without launching the Flutter app. It handles the complete gatelog checkout/checkin flow natively: connects to the backend via WebSocket, generates a QR code, and shows real-time status.

This is the same mechanism used by Google Assistant, Facebook Messenger chat heads, and Truecaller caller ID.

## Why not just open the Flutter app?

Opening the Flutter app from a widget requires:
1. Android launches the app process
2. Flutter engine initializes (~1-2 seconds)
3. Dart VM boots
4. App navigates to the gatelog page

The overlay skips all of this. It's a native Android view that appears instantly, does one thing, and dismisses. The user never leaves their current screen.

---

## How it works (high level)

```
Home screen widget: User taps "To Khokha"
    |
    v
GateLogOverlayActivity (transparent, invisible)
    |-- Checks SYSTEM_ALERT_WINDOW permission
    |-- If not granted: opens Android Settings for permission
    |-- If granted: starts GateLogOverlayService
    |-- Finishes immediately (Activity is gone)
    |
    v
GateLogOverlayService (ForegroundService)
    |-- Shows a foreground notification ("Gatelog in progress...")
    |-- Adds overlay view to WindowManager
    |-- Reads auth token from Flutter's SharedPreferences
    |-- Makes HTTP call to get userId (OkHttp)
    |-- Opens WebSocket to backend (OkHttp WebSocket)
    |-- On CONNECTION event: generates QR code (ZXing)
    |-- Displays QR in overlay
    |-- On ENTRY_ADDED: shows success, syncs widget, auto-dismisses
    |
    v
User sees floating card with QR code over their current screen
    |-- Tap scrim (dark background) or X to dismiss
    |-- After success: auto-dismisses in 2.5 seconds
```

---

## Key Android concepts

### SYSTEM_ALERT_WINDOW permission

This is a special permission that lets an app draw on top of other apps. It's not a normal runtime permission — the user must manually toggle it in Settings > Apps > [App] > Display over other apps.

```kotlin
// Check if granted
Settings.canDrawOverlays(context) // returns Boolean

// Open settings page for the user to grant it
val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
    Uri.parse("package:$packageName"))
startActivityForResult(intent, REQUEST_CODE)
```

Once granted, it persists until the user revokes it. We only ask once.

### WindowManager + TYPE_APPLICATION_OVERLAY

`WindowManager` is the system service that manages all windows on screen. We add our overlay view to it:

```kotlin
val params = WindowManager.LayoutParams(
    MATCH_PARENT, MATCH_PARENT,
    TYPE_APPLICATION_OVERLAY,   // Draws over other apps
    FLAG_NOT_TOUCH_MODAL,       // Allows touch on areas outside our view
    PixelFormat.TRANSLUCENT     // Supports transparency
)
params.screenBrightness = 1.0f  // Max brightness for QR scanning

windowManager.addView(overlayView, params)
```

This is fundamentally different from an Activity — there's no activity stack, no back button handling, no lifecycle. It's a raw view floating on the screen.

### ForegroundService

Android requires a visible notification for long-running background work (since Android 8.0). Our overlay service creates a low-priority notification:

```
Gatelog
Gate log in progress...
```

This keeps the service alive while the overlay is visible. When the overlay dismisses, the service stops and the notification disappears.

On Android 14+, foreground services must declare a type. We use `dataSync` since we're syncing data with a backend server.

**Required permissions:**
```xml
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW" />
```

---

## The overlay UI

The overlay layout (`gatelog_overlay.xml`) is a full-screen `FrameLayout` with:

1. **Scrim** — semi-transparent black background (`#99000000`). Tapping dismisses the overlay.
2. **Card** — centered dark card (`#262626`, 24dp radius) containing:
   - Header: "Gatelog" title + close button (X)
   - Destination label: "To Khokha" (green)
   - QR code: 240x240dp white background with generated QR
   - Progress spinner: shown while connecting
   - Success icon: green circle with checkmark
   - Status text: "Connecting...", "Scan this QR at the gate", "Checked out successfully!", etc.
   - For "Others" destination: EditText + "Continue" button

Unlike widget layouts, overlay layouts use the **full Android View system** — any view is allowed, including EditText, ImageView with dynamic bitmaps, animations, etc.

---

## Data access

### Auth token

The Flutter app stores the auth token in SharedPreferences via the `shared_preferences` plugin. On Android, this maps to:

```kotlin
val prefs = getSharedPreferences("FlutterSharedPreferences", MODE_PRIVATE)
val token = prefs.getString("flutter.accessToken", null)
```

Note: Flutter's `shared_preferences` plugin prefixes all keys with `flutter.` and uses a file named `FlutterSharedPreferences`.

### Environment variables

Build-time env vars (`--dart-define`) are injected into Android's `BuildConfig` via `build.gradle`:

```groovy
buildConfigField "String", "GATELOG_WSS_URL", "\"${dartEnvironmentVariables['GATELOG_WEBSOCKET_URL'] ?: ''}\""
buildConfigField "String", "SECURITY_KEY", "\"${dartEnvironmentVariables['SECURITY_KEY'] ?: ''}\""
buildConfigField "String", "GATELOG_SERVER_URL", "\"${dartEnvironmentVariables['GATELOG_SERVER_URL'] ?: ''}\""
buildConfigField "String", "SERVER_URL", "\"${dartEnvironmentVariables['SERVER_URL'] ?: ''}\""
```

Accessed in Kotlin as:
```kotlin
val wssUrl = BuildConfig.GATELOG_WSS_URL
val securityKey = BuildConfig.SECURITY_KEY
```

This requires `buildFeatures { buildConfig = true }` in `build.gradle` (disabled by default in AGP 8.0+).

---

## WebSocket protocol

The overlay replicates the exact same WebSocket protocol as the Flutter gatelog package.

### Connection

```kotlin
val request = Request.Builder()
    .url(BuildConfig.GATELOG_WSS_URL)  // wss://...
    .addHeader("Content-Type", "application/json")
    .addHeader("security-key", BuildConfig.SECURITY_KEY)
    .addHeader("Authorization", "Bearer $authToken")
    .build()

client.newWebSocket(request, webSocketListener)
```

### Events

Events arrive as JSON with an `eventName` field:

| eventName | Description | Overlay action |
|-----------|-------------|----------------|
| `CONNECTION` | Server assigned a connectionId | Set connectionId in QR data, generate QR, show it |
| `REQUEST_RECEIVED` | Gate scanner read the QR | Hide QR, show "QR scanned, processing..." |
| `TIMEOUT` | No scan within server timeout | Close socket, reconnect, re-show QR |
| `ENTRY_ADDED` | Checkout successful | Show success, sync widget (checked_out=true), auto-dismiss |
| `ENTRY_CLOSED` | Checkin successful | Show success, sync widget (checked_out=false), auto-dismiss |
| `ERROR` | Server error | Show error message |

### QR data format

**Checkout QR:**
```json
{
    "destination": "Khokha",
    "connectionId": "abc-123",
    "userId": "user-456",
    "isExit": true
}
```

**Checkin QR:**
```json
{
    "connectionId": "abc-123",
    "entryId": "entry-789",
    "isExit": false
}
```

The QR code is generated using ZXing (`com.google.zxing:core`) as a `Bitmap` and displayed in an `ImageView`.

---

## HTTP API calls

The overlay makes two HTTP calls using OkHttp (no Flutter/Dio involved):

### 1. Get User ID (for checkout)
```
GET {SERVER_URL}/user/getUserid
Headers:
  Content-Type: application/json
  security-key: {SECURITY_KEY}
  Authorization: Bearer {authToken}

Response: { "userId": "..." }
```

### 2. Get Latest Entry (for checkin)
```
GET {GATELOG_SERVER_URL}/history?page=1&size=1
Headers:
  Content-Type: application/json
  security-key: {SECURITY_KEY}
  Authorization: Bearer {authToken}

Response: { "history": [{ "_id": "...", "isClosed": false, ... }] }
```

For checkin, the overlay checks if the latest entry is unclosed (`isClosed: false`) and uses its `_id` as the `entryId` in the QR.

---

## Widget state sync

After a successful checkout/checkin, the overlay syncs state back to the widget:

```kotlin
val prefs = getSharedPreferences("HomeWidgetPreferences", MODE_PRIVATE)
prefs.edit().apply {
    putBoolean("gl_is_checked_out", isCheckedOut)
    putString("gl_destination", destination ?: "")
    apply()
}

// Trigger widget refresh
val intent = Intent(context, GateLogHomeWidgetProvider::class.java)
intent.action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, widgetIds)
sendBroadcast(intent)
```

This updates the widget immediately — it flips from showing destination buttons to showing the "Check into Campus" state (or vice versa).

---

## File structure

```
android/app/src/main/
  kotlin/com/swciitg/onestop2/
    GateLogOverlayActivity.kt    # Permission check trampoline (73 lines)
    GateLogOverlayService.kt     # Overlay + WSS + QR service (509 lines)
  res/
    layout/
      gatelog_overlay.xml         # Overlay layout (151 lines)
    drawable/
      gatelog_overlay_card.xml    # Dark card background (24dp radius)
      gatelog_overlay_button.xml  # Green submit button (20dp radius)
      gatelog_overlay_success.xml # Green circle for checkmark
```

---

## Manifest registration

```xml
<!-- Transparent trampoline for permission check -->
<activity
    android:name=".GateLogOverlayActivity"
    android:theme="@android:style/Theme.Translucent.NoTitleBar"
    android:exported="false"
    android:excludeFromRecents="true"
    android:taskAffinity="" />

<!-- Foreground service for WSS + QR overlay -->
<service
    android:name=".GateLogOverlayService"
    android:foregroundServiceType="dataSync"
    android:exported="false" />
```

- `Theme.Translucent.NoTitleBar` — Activity has no visible UI
- `excludeFromRecents` — Doesn't show in recent apps
- `taskAffinity=""` — Runs in its own task stack, doesn't interfere with the Flutter app
- `foregroundServiceType="dataSync"` — Required for Android 14+ foreground services

---

## Dependencies

Added to `android/app/build.gradle`:
```groovy
implementation 'com.squareup.okhttp3:okhttp:4.12.0'   // HTTP + WebSocket client
implementation 'com.google.zxing:core:3.5.3'           // QR code generation
```

OkHttp handles both the REST API calls and the WebSocket connection. ZXing generates QR codes as bitmaps.

---

## iOS equivalent?

There is no iOS equivalent. iOS does not allow apps to draw over other apps (no `SYSTEM_ALERT_WINDOW` equivalent). The closest alternatives are:

- **Live Activities** (iOS 16.1+) — persistent banner on lock screen, can show QR
- **Dynamic Island** (iPhone 14 Pro+) — compact status indicator
- Neither provides a true overlay. iOS widget taps always open the full app.

The gatelog widget on iOS continues to use deep links to open the Flutter app.

---

## Debugging tips

1. **Overlay not showing?** Check `Settings.canDrawOverlays()` — the permission may not be granted.
2. **Service killed immediately?** Ensure `startForeground()` is called within 5 seconds of `startForegroundService()`.
3. **Auth token null?** The user may not be logged in, or the SharedPreferences file name/key may have changed in a newer `shared_preferences` plugin version.
4. **WebSocket not connecting?** Check that `BuildConfig.GATELOG_WSS_URL` is not empty — it's only populated when `--dart-define=GATELOG_WEBSOCKET_URL=...` is passed at build time.
5. **QR not generating?** ZXing throws if the data string is empty or too long. Check that connectionId was received from the CONNECTION event.
6. **Widget not updating after overlay success?** The SharedPreferences file used by `home_widget` may have a different name than `HomeWidgetPreferences`. Check the actual file in `/data/data/com.swciitg.onestop2/shared_prefs/`.
