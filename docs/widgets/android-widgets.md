# Android Home Screen Widgets

> A guide for Flutter developers who don't know Android platform specifics.

## What are Android widgets?

Android widgets are small UI elements that live on the home screen. They're **not** Flutter widgets — they're entirely native Android views rendered by the OS. They run outside your app process. Your app can be killed and the widget still shows data.

Think of them as read-only snapshots of your app's data, rendered by Android itself.

## Key concepts

### RemoteViews

Android widgets use `RemoteViews` — a restricted view system that only supports a handful of basic views:
- `TextView` (text labels and buttons)
- `ImageView` (images)
- `LinearLayout`, `RelativeLayout`, `FrameLayout` (containers)
- `ProgressBar`

You **cannot** use custom views, Canvas drawing, RecyclerView, or anything interactive beyond click listeners. This is why widget UIs look simple.

You modify RemoteViews through method calls like:
```kotlin
views.setTextViewText(R.id.myText, "Hello")
views.setViewVisibility(R.id.mySection, View.GONE)
views.setTextColor(R.id.myText, 0xFF000000.toInt())
views.setInt(R.id.myView, "setBackgroundResource", R.drawable.bg)
```

### AppWidgetProvider

Every widget has a provider class that extends `AppWidgetProvider` (or in our case, `HomeWidgetProvider` from the `home_widget` Flutter package). This is like a BroadcastReceiver that Android calls when it needs to update the widget.

The main method is `onUpdate()` — called every N milliseconds (defined in widget info XML) and whenever data changes.

### Widget info XML

Defines widget metadata: minimum size, update frequency, resize behavior. Located in `res/xml/`.

### Widget layout XML

Standard Android XML layout, but limited to RemoteViews-compatible views. Located in `res/layout/`.

### PendingIntent

Since widgets run outside your app, click handlers use `PendingIntent` — a pre-built intent that Android executes when the user taps a view. You can make it:
- Open an Activity (`PendingIntent.getActivity()`)
- Send a Broadcast (`PendingIntent.getBroadcast()`)
- Start a Service (`PendingIntent.getService()`)

### SharedPreferences

Widgets read data from SharedPreferences. The `home_widget` Flutter package writes to a file called `HomeWidgetPreferences`. The native widget provider reads from this same file in `onUpdate()` via the `widgetData` parameter.

---

## How data flows: Flutter -> Widget

```
Flutter app                         Android OS
-----------                         ----------
HomeWidget.saveWidgetData()  --->   Writes to HomeWidgetPreferences (SharedPreferences)
HomeWidget.updateWidget()    --->   Triggers ACTION_APPWIDGET_UPDATE broadcast
                                    Android calls YourWidgetProvider.onUpdate()
                                    Provider reads SharedPreferences, builds RemoteViews
                                    Android renders the widget on home screen
```

On iOS, the flow is similar but uses UserDefaults via App Group instead of SharedPreferences.

### The iOS update caveat

On Android, we explicitly call `HomeWidget.updateWidget()` to refresh. On iOS, we **don't** — calling `reloadTimelines` triggers a WidgetKit scene snapshot that recursively traverses Flutter's deep UIView hierarchy (24,000+ levels), causing a stack overflow crash. iOS widgets instead rely on their 5-minute timeline refresh cycle to pick up new UserDefaults data.

---

## Our widgets

We have 3 widgets, all registered in `AndroidManifest.xml` as `<receiver>` elements:

| Widget | Provider class | Layout | Size | Update interval |
|--------|---------------|--------|------|-----------------|
| Timetable | `TimetableHomeWidgetProvider` | `timetable_home_widget.xml` | 4x2 cells (250x110dp) | 5 min |
| Food | `FoodHomeWidgetProvider` | `food_home_widget.xml` | 2x2 cells (110x110dp) | 5 min |
| Gatelog | `GateLogHomeWidgetProvider` | `gatelog_home_widget.xml` | 2x2 cells (110x110dp) | 5 min |

---

## Timetable Widget

**Files:**
- `android/.../TimetableHomeWidgetProvider.kt` (337 lines)
- `android/.../res/layout/timetable_home_widget.xml`
- `android/.../res/xml/timetable_home_widget_info.xml`
- `lib/services/home_timetable_widget_service.dart`

**SharedPreferences keys:**
| Key | Type | Description |
|-----|------|-------------|
| `tt_week_data` | String (JSON) | Full week timetable: `{ "Monday": [{code, course, timing}, ...], ... }` |
| `tt_is_dark` | bool | Dark mode flag |
| `tt_deeplink` | String | Deep link URL (`onestopiitg://timetable`) |

**How it works:**
1. Flutter's `HomeTimetableWidgetService.syncFullTimetable()` serializes the entire week's timetable as JSON and saves it to SharedPreferences.
2. Every 5 minutes (or on explicit update), `TimetableHomeWidgetProvider.onUpdate()` is called.
3. The provider parses the JSON, figures out today's day, and computes which class is ongoing and which are upcoming based on the current system time.
4. It renders a two-column layout:
   - **Left card**: Current/next class with a countdown timer ("23 MIN LEFT")
   - **Right column**: Up to 2 upcoming classes
5. Special states: "Happy Weekend!" on Sat/Sun, "No classes today" if empty.

**Timing parsing:**
The timing string format is `"09:00 - 09:55 AM"`. The Kotlin provider parses this with regex, converts to epoch millis for today, and compares against `System.currentTimeMillis()`. Each class is assumed to be 55 minutes long.

**Drawables:**
- `timetable_widget_background_dark/light.xml` — Widget container background
- `timetable_widget_inner_card_dark/light.xml` — Inner card backgrounds
- `timetable_widget_left_card_green_dark/light.xml` — Left card when class is ongoing (green)
- `timetable_widget_left_card_blue_dark/light.xml` — Left card when class is upcoming (blue)

---

## Food Widget

**Files:**
- `android/.../FoodHomeWidgetProvider.kt` (91 lines)
- `android/.../res/layout/food_home_widget.xml`
- `android/.../res/xml/food_home_widget_info.xml`
- `lib/services/home_food_widget_service.dart`

**SharedPreferences keys:**
| Key | Type | Description |
|-----|------|-------------|
| `food_meal_name` | String | e.g. "Lunch", "Dinner" |
| `food_meal_items` | String | Comma-separated items: "Rice, Dal, Paneer" |
| `food_end_time` | String | e.g. "2:00 PM" |
| `food_is_dark` | bool | Dark mode flag |
| `food_deeplink` | String | `onestopiitg://home2?tab=1` |

**How it works:**
1. Flutter's `HomeFoodWidgetService.syncMealData()` saves the current meal name, items, and end time.
2. Provider reads these, displays meal name + end time in a badge, and items below.
3. If no data, shows "No data available".
4. Tapping anywhere opens the food tab in the app via deep link.

**Drawables:**
- `food_widget_background_dark/light.xml` — Widget container background

---

## Gatelog Widget

**Files:**
- `android/.../GateLogHomeWidgetProvider.kt` (178 lines)
- `android/.../res/layout/gatelog_home_widget.xml`
- `android/.../res/xml/gatelog_home_widget_info.xml`
- `lib/services/home_gatelog_widget_service.dart`

**SharedPreferences keys:**
| Key | Type | Description |
|-----|------|-------------|
| `gl_is_checked_out` | bool | true = user is outside campus |
| `gl_destination` | String | Last checkout destination |
| `gl_is_dark` | bool | Dark mode flag |

**Two UI states:**

**Default (checked in):**
- Shows 3 buttons: "To City", "To Khokha", "Others"
- Each button launches the **Gatelog Overlay** (see overlay docs) with the destination pre-selected

**Checked out:**
- Shows "Check into Campus" label
- Shows gate closing info: "KHOKHA CLOSES IN 2 HRS 30 MINS"
- Shows "Check-In" button that launches the overlay with `autoCheckIn=true`

**Gate closing logic (computed natively every update cycle):**
- Khokha gate closes at 10:00 PM (22:00)
- KV Gate closes at 10:30 PM (22:30)
- Main Gate is always open
- After both close: "ENTER VIA MAIN GATE"

**Click behavior:**
- **Action buttons** (To City, To Khokha, Others, Check-In) → Launch `GateLogOverlayActivity` (overlay, no app launch)
- **Widget background tap** → Deep link to Flutter app's gatelog page (full app experience)

**Drawables:**
- `gatelog_widget_background_dark/light.xml` — Widget container (16dp radius)
- `gatelog_widget_button_outline_dark/light.xml` — Button outlines (20dp radius)

---

## Theme support

All widgets support dark/light mode. The Flutter app saves an `is_dark` flag per widget. The native provider reads this flag and swaps:
- Background drawables (dark gray vs white)
- Text colors (white vs black, with green accent)
- Button outlines (dark vs light borders)

The color scheme follows the app's design system:
| Token | Light | Dark |
|-------|-------|------|
| green500 | `#1AB056` | `#14BD56` |
| gray600 | `#6E6F77` | `#9B9B9B` |
| gray500 | `#98999F` | `#6F6F6F` |
| background | `#FFFFFF` | `#262626` |

---

## Deep linking

Widgets use the custom URL scheme `onestopiitg://` to communicate with the Flutter app.

| Deep link | Target |
|-----------|--------|
| `onestopiitg://gatelog?destination=City` | Gatelog page with City pre-selected |
| `onestopiitg://gatelog?autoCheckIn=true` | Gatelog page in check-in mode |
| `onestopiitg://timetable` | Timetable page |
| `onestopiitg://home2?tab=1` | Home page, food tab |

These are handled by `DeepLinkService` in Flutter which listens via the `app_links` package.

---

## Manifest registration

Each widget is registered in `AndroidManifest.xml` as a `<receiver>`:

```xml
<receiver
    android:name=".GateLogHomeWidgetProvider"
    android:label="Gatelog"
    android:exported="false">
    <intent-filter>
        <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
    </intent-filter>
    <meta-data
        android:name="android.appwidget.provider"
        android:resource="@xml/gatelog_home_widget_info" />
</receiver>
```

The `label` is what users see in the widget picker. The `meta-data` points to the widget info XML with sizing and update config.

---

## File structure

```
android/app/src/main/
  kotlin/com/swciitg/onestop2/
    TimetableHomeWidgetProvider.kt
    FoodHomeWidgetProvider.kt
    GateLogHomeWidgetProvider.kt
    GateLogOverlayActivity.kt       # (see overlay docs)
    GateLogOverlayService.kt        # (see overlay docs)
    MainActivity.kt
    RestartActivity.kt
  res/
    layout/
      timetable_home_widget.xml
      food_home_widget.xml
      gatelog_home_widget.xml
      gatelog_overlay.xml            # (see overlay docs)
    xml/
      timetable_home_widget_info.xml
      food_home_widget_info.xml
      gatelog_home_widget_info.xml
    drawable/
      timetable_widget_background_dark.xml
      timetable_widget_background_light.xml
      timetable_widget_inner_card_dark.xml
      timetable_widget_inner_card_light.xml
      timetable_widget_left_card_green_dark.xml
      timetable_widget_left_card_green_light.xml
      timetable_widget_left_card_blue_dark.xml
      timetable_widget_left_card_blue_light.xml
      food_widget_background_dark.xml
      food_widget_background_light.xml
      gatelog_widget_background_dark.xml
      gatelog_widget_background_light.xml
      gatelog_widget_button_outline_dark.xml
      gatelog_widget_button_outline_light.xml
```

```
lib/services/
  home_timetable_widget_service.dart    # Syncs timetable data to widget
  home_food_widget_service.dart         # Syncs food data to widget
  home_gatelog_widget_service.dart       # Syncs gatelog state to widget
  deep_link_service.dart                # Handles widget deep links
```
