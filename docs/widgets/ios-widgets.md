# iOS Home Screen Widgets (WidgetKit)

> A guide for Flutter developers who don't know iOS platform specifics.

## What are iOS widgets?

iOS widgets use Apple's **WidgetKit** framework (iOS 14+). Like Android widgets, they live on the home screen and show data from your app. But the model is fundamentally different:

- iOS widgets are **timeline-based** — you give the OS a list of snapshots (entries) with timestamps, and iOS renders them at the right time. You don't "push" updates; iOS "pulls" from your timeline.
- Widgets are rendered using **SwiftUI** — Apple's declarative UI framework (similar in philosophy to Flutter's widget tree).
- Widgets are **read-only** — the only interaction is tapping, which opens the app via a deep link (`widgetURL` or `Link`).

## Key concepts

### TimelineProvider

Every widget has a `TimelineProvider` that the OS calls to get timeline entries. It has 3 methods:

```swift
struct MyProvider: TimelineProvider {
    // Quick placeholder for loading state
    func placeholder(in context: Context) -> MyEntry { ... }

    // Single snapshot for widget gallery preview
    func getSnapshot(in context: Context, completion: @escaping (MyEntry) -> ()) { ... }

    // The actual timeline: array of entries with dates
    func getTimeline(in context: Context, completion: @escaping (Timeline<MyEntry>) -> ()) {
        let entry = MyEntry(date: Date(), ...)
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }
}
```

The `policy: .after(nextUpdate)` tells iOS to call `getTimeline` again after 5 minutes. iOS may delay this — it's a *hint*, not a guarantee.

### TimelineEntry

A struct conforming to `TimelineEntry` that holds the data for one snapshot. Must have a `date` property.

### Widget configuration

Defined with the `@main` attribute (or a `WidgetBundle` for multiple widgets):

```swift
struct MyWidget: Widget {
    let kind: String = "MyWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MyProvider()) { entry in
            MyWidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("What it does.")
        .supportedFamilies([.systemSmall])
    }
}
```

### Widget families (sizes)

| Family | Size | Description |
|--------|------|-------------|
| `.systemSmall` | ~2x2 | Small square, single tap target |
| `.systemMedium` | ~4x2 | Wide rectangle |
| `.systemLarge` | ~4x4 | Large square |

### UserDefaults (App Groups)

iOS widgets run in a separate process from the app. They share data via **App Groups** — a shared container both the app and widget extension can access.

```swift
let defaults = UserDefaults(suiteName: "group.com.swciitg.onestop2")
let isCheckedOut = defaults?.bool(forKey: "gl_is_checked_out") ?? false
```

The Flutter `home_widget` package writes to this same group via `HomeWidget.setAppGroupId()`.

### Deep links

Widget interactions use `Link` views or `.widgetURL()` modifier:

```swift
Link(destination: URL(string: "onestopiitg://gatelog?destination=City")!) {
    Text("To City")
}
```

Tapping always opens the containing app. There's no way to avoid this on iOS.

---

## How data flows: Flutter -> Widget

```
Flutter app                              iOS
-----------                              ---
HomeWidget.saveWidgetData()  --->   Writes to UserDefaults (App Group)
                                    (no explicit update trigger on iOS!)
                                    Every ~5 min, iOS calls getTimeline()
                                    Provider reads UserDefaults
                                    Builds SwiftUI view
                                    iOS renders widget on home screen
```

**Why no explicit update on iOS?**
Calling `WidgetCenter.shared.reloadTimelines()` from Flutter (via `HomeWidget.updateWidget()`) triggers a WidgetKit scene snapshot. This recursively traverses Flutter's UIView hierarchy (24,000+ levels deep), causing a stack overflow crash. So we skip it and let the natural 5-minute refresh cycle handle updates.

---

## Our widget bundle

All 3 widgets live in a single file: `ios/TimetableWidget/TimetableWidget.swift` (687 lines).

They're bundled together in:
```swift
@main
struct OneStopWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimetableWidget()
        FoodWidget()
        GateLogWidget()
    }
}
```

**Extension target:** `TimetableWidgetExtension`
**Bundle ID:** `com.swciitg.onestop2swc2022.TimetableWidget`
**App Group:** `group.com.swciitg.onestop2`
**Minimum iOS:** 14.0

---

## Timetable Widget

**Size:** `.systemMedium` (wide rectangle)
**Refresh:** Every 5 minutes

**UserDefaults keys:**
| Key | Type | Description |
|-----|------|-------------|
| `tt_week_data` | String (JSON) | Full week timetable |
| `tt_is_dark` | bool | Dark mode |
| `tt_deeplink` | String | Deep link URL |

**How it works:**
1. `TimetableProvider.getTimeline()` reads `tt_week_data` JSON from UserDefaults.
2. Parses today's courses, computes which is ongoing/upcoming using `Date()`.
3. Each course timing is parsed from format `"09:00 - 09:55 AM"`.
4. The `WidgetCourse` model determines `isOngoing` (within 55-min window) and `isUpcoming` (start > now).
5. SwiftUI view renders:
   - Left card: current/next class with green (ongoing) or blue (upcoming) accent
   - Right column: up to 3 upcoming classes
   - Special states: "Happy Weekend!", "No Classes Today"

**Deep link:** `onestopiitg://timetable`

---

## Food Widget

**Size:** `.systemSmall` (small square)
**Refresh:** Every 15 minutes

**UserDefaults keys:**
| Key | Type | Description |
|-----|------|-------------|
| `food_meal_name` | String | e.g. "Lunch" |
| `food_meal_items` | String | Comma-separated items |
| `food_end_time` | String | e.g. "2:00 PM" |
| `food_is_dark` | bool | Dark mode |
| `food_deeplink` | String | Deep link URL |

**How it works:**
1. `FoodProvider.getTimeline()` reads meal data from UserDefaults.
2. Shows meal name and end time in a badge, menu items below.
3. "No data" fallback if meal name is empty.

**Deep link:** `onestopiitg://home2?tab=1`

---

## Gatelog Widget

**Size:** `.systemSmall` (small square)
**Refresh:** Every 5 minutes

**UserDefaults keys:**
| Key | Type | Description |
|-----|------|-------------|
| `gl_is_checked_out` | bool | true = outside campus |
| `gl_destination` | String | Last destination |
| `gl_is_dark` | bool | Dark mode |

**Two UI states:**

**Default (checked in):**
- 3 buttons: "To City", "To Khokha", "Others"
- Each is a `Link` view with deep link `onestopiitg://gatelog?destination=X`

**Checked out:**
- "Check into Campus" label
- Gate closing info (computed in Swift, same logic as Android)
- "Check-In" button with deep link `onestopiitg://gatelog?autoCheckIn=true`

**Gate closing logic (computed in Swift):**
```
Khokha closes at 22:00 (10 PM)
KV Gate closes at 22:30 (10:30 PM)
After both: "ENTER VIA MAIN GATE"
```

On iOS, tapping any button opens the full Flutter app (no overlay alternative — iOS doesn't allow drawing over other apps).

---

## Theme support

All widgets use a shared `WidgetColors` struct:

```swift
struct WidgetColors {
    let background: Color       // Widget background
    let cardBg: Color           // Inner card background
    let textPrimary: Color      // Titles, main text
    let textSecondary: Color    // Subtitles, labels
    let statusOngoingBg: Color  // Green accent
    let statusUpcomingBg: Color // Blue accent
    // ... more
}
```

Two presets: `.light` and `.dark`, selected based on the `is_dark` flag from UserDefaults.

| Token | Light | Dark |
|-------|-------|------|
| background | White | `#262626` |
| cardBg | `#F4F5F5` | `#323232` |
| green | `#1AB056` | `#14BD56` |

---

## How the widget extension is structured

```
ios/TimetableWidget/
    TimetableWidget.swift           # ALL widget code (3 widgets, ~687 lines)
    TimetableWidget.entitlements    # App Group entitlement
    Info.plist                      # Extension metadata
```

The entitlements file grants access to the shared App Group:
```xml
<key>com.apple.security.application-groups</key>
<array>
    <string>group.com.swciitg.onestop2</string>
</array>
```

The main app's `Runner.entitlements` has the same App Group, enabling data sharing.

---

## Limitations vs Android

| Feature | Android | iOS |
|---------|---------|-----|
| Explicit refresh | Yes (`updateWidget()`) | No (causes crash, use timeline) |
| Interactive buttons | Yes (PendingIntent) | Deep links only (opens app) |
| Custom views | Limited (RemoteViews) | Full SwiftUI |
| Background overlay | Yes (SYSTEM_ALERT_WINDOW) | Not possible |
| Update latency | Instant (on explicit update) | Up to 5 minutes |
| Process model | Widget runs in app process | Widget runs in separate extension process |

---

## Key iOS-specific gotchas

1. **Don't call `HomeWidget.updateWidget()` on iOS** — causes stack overflow. Wrap in `Platform.isAndroid` check.
2. **Timeline refresh is approximate** — iOS may delay your 5-min refresh if the device is low on battery or the widget isn't visible.
3. **Widget extension has a memory limit** (~30MB) — don't load heavy data.
4. **Previews require running on device** — SwiftUI widget previews in Xcode often fail for Flutter projects.
5. **App Group ID must match exactly** between the main app's entitlements, the widget extension's entitlements, and the Flutter `HomeWidget.setAppGroupId()` call.
