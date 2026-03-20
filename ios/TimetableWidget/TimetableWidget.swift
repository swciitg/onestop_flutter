import WidgetKit
import SwiftUI

// MARK: - Data Model

struct WidgetCourse {
    let code: String
    let course: String
    let timing: String
    let startDate: Date

    var isOngoing: Bool {
        let now = Date()
        let end = startDate.addingTimeInterval(55 * 60)
        return startDate <= now && now < end
    }

    var isUpcoming: Bool {
        return startDate > Date()
    }
}

// MARK: - Timeline Entry

struct TimetableEntry: TimelineEntry {
    let date: Date
    let currentClass: WidgetCourse?
    let upcomingClasses: [WidgetCourse]
    let isDark: Bool
    let deeplink: String
    let isWeekend: Bool
    let noClasses: Bool
}

// MARK: - Timeline Provider

struct TimetableProvider: TimelineProvider {
    private let appGroupId = "group.com.swciitg.onestop2"

    func placeholder(in context: Context) -> TimetableEntry {
        TimetableEntry(
            date: Date(),
            currentClass: nil,
            upcomingClasses: [],
            isDark: false,
            deeplink: "onestopiitg://timetable",
            isWeekend: false,
            noClasses: true
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (TimetableEntry) -> Void) {
        completion(buildEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TimetableEntry>) -> Void) {
        let entry = buildEntry()
        // Refresh every 5 minutes
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func buildEntry() -> TimetableEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let isDark = defaults?.bool(forKey: "tt_is_dark") ?? false
        let deeplink = defaults?.string(forKey: "tt_deeplink") ?? "onestopiitg://timetable"

        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: Date())
        // Sunday = 1, Saturday = 7
        if weekday == 1 || weekday == 7 {
            return TimetableEntry(
                date: Date(),
                currentClass: nil,
                upcomingClasses: [],
                isDark: isDark,
                deeplink: deeplink,
                isWeekend: true,
                noClasses: false
            )
        }

        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        let todayName = dayNames[weekday - 1]

        guard let jsonString = defaults?.string(forKey: "tt_week_data"),
              let data = jsonString.data(using: .utf8),
              let weekData = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let todayCourses = weekData[todayName] as? [[String: String]] else {
            return TimetableEntry(
                date: Date(),
                currentClass: nil,
                upcomingClasses: [],
                isDark: isDark,
                deeplink: deeplink,
                isWeekend: false,
                noClasses: true
            )
        }

        let courses = todayCourses.compactMap { dict -> WidgetCourse? in
            guard let code = dict["code"],
                  let course = dict["course"],
                  let timing = dict["timing"],
                  let startDate = parseTimingToDate(timing) else { return nil }
            return WidgetCourse(code: code, course: course, timing: timing, startDate: startDate)
        }.sorted { $0.startDate < $1.startDate }

        let now = Date()
        let ongoingClass = courses.first { $0.isOngoing }
        let upcomingAll = courses.filter { $0.startDate > now }

        let currentClass = ongoingClass ?? upcomingAll.first
        let upcoming: [WidgetCourse]
        if ongoingClass != nil {
            upcoming = Array(upcomingAll.prefix(3))
        } else {
            upcoming = Array(upcomingAll.dropFirst().prefix(3))
        }

        let noClasses = currentClass == nil && upcoming.isEmpty

        return TimetableEntry(
            date: Date(),
            currentClass: currentClass,
            upcomingClasses: upcoming,
            isDark: isDark,
            deeplink: deeplink,
            isWeekend: false,
            noClasses: noClasses
        )
    }

    /// Parse timing string like "09:00 - 09:55 AM" to get start time as Date today
    private func parseTimingToDate(_ timing: String) -> Date? {
        // Extract only the START time (before " - ") + AM/PM suffix.
        // Using the full format "hh:mm - hh:mm a" causes the second hh:mm to
        // overwrite the first, returning the END time instead of the start.
        let parts = timing.components(separatedBy: " - ")
        guard parts.count == 2 else { return nil }
        let startTimeStr = parts[0].trimmingCharacters(in: .whitespaces)
        let amPm = String(parts[1].trimmingCharacters(in: .whitespaces).suffix(2))

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm a"

        guard let parsed = formatter.date(from: "\(startTimeStr) \(amPm)") else { return nil }

        let calendar = Calendar.current
        let parsedComponents = calendar.dateComponents([.hour, .minute], from: parsed)
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.hour = parsedComponents.hour
        todayComponents.minute = parsedComponents.minute
        todayComponents.second = 0

        return calendar.date(from: todayComponents)
    }
}

// MARK: - Theme Colors

struct WidgetColors {
    let background: Color
    let innerCard: Color
    let ongoingCard: Color
    let upcomingCard: Color
    let titleText: Color
    let dateText: Color
    let courseNameText: Color
    let statusOngoingBg: Color
    let statusUpcomingBg: Color
    let timeOngoing: Color
    let timeUpcoming: Color

    // OColor mappings from onestop_ui/lib/utils/colors.dart
    static func colors(isDark: Bool) -> WidgetColors {
        if isDark {
            return WidgetColors(
                background: Color(red: 0x26/255, green: 0x26/255, blue: 0x26/255),       // OColor.white (dark)
                innerCard: Color(red: 0x1C/255, green: 0x1C/255, blue: 0x1C/255),        // OColor.gray100 (dark)
                ongoingCard: Color(red: 0x2D/255, green: 0x40/255, blue: 0x35/255),       // OColor.green100 (dark)
                upcomingCard: Color(red: 0x32/255, green: 0x32/255, blue: 0x32/255),      // OColor.gray200 (dark)
                titleText: Color(red: 0xFD/255, green: 0xFD/255, blue: 0xFC/255),         // OColor.black (dark)
                dateText: Color(red: 0x6F/255, green: 0x6F/255, blue: 0x6F/255),          // OColor.gray500 (dark)
                courseNameText: Color(red: 0x9B/255, green: 0x9B/255, blue: 0x9B/255),    // OColor.gray600 (dark)
                statusOngoingBg: Color(red: 0x14/255, green: 0xBD/255, blue: 0x56/255),   // OColor.green500 (dark)
                statusUpcomingBg: Color(red: 0x38/255, green: 0x87/255, blue: 0xFF/255),  // OColor.blue500 (dark)
                timeOngoing: Color(red: 0x08/255, green: 0x5E/255, blue: 0x2A/255),       // OColor.green700 (dark)
                timeUpcoming: Color(red: 0x1A/255, green: 0x75/255, blue: 0xFF/255)       // OColor.blue600 (dark)
            )
        } else {
            return WidgetColors(
                background: Color.white,                                                    // OColor.white (light)
                innerCard: Color(red: 0xF4/255, green: 0xF5/255, blue: 0xF5/255),         // OColor.gray100 (light)
                ongoingCard: Color(red: 0xDC/255, green: 0xEF/255, blue: 0xE4/255),       // OColor.green100 (light)
                upcomingCard: Color(red: 0xD6/255, green: 0xE6/255, blue: 0xFF/255),      // OColor.blue100 (light)
                titleText: Color.black,                                                     // OColor.black (light)
                dateText: Color(red: 0x98/255, green: 0x99/255, blue: 0x9F/255),          // OColor.gray500 (light)
                courseNameText: Color(red: 0x6E/255, green: 0x6F/255, blue: 0x77/255),    // OColor.gray600 (light)
                statusOngoingBg: Color(red: 0x1A/255, green: 0xB0/255, blue: 0x56/255),   // OColor.green500 (light)
                statusUpcomingBg: Color(red: 0x00/255, green: 0x5F/255, blue: 0xF0/255),  // OColor.blue500 (light)
                timeOngoing: Color(red: 0x08/255, green: 0x5E/255, blue: 0x2A/255),       // OColor.green700 (light)
                timeUpcoming: Color(red: 0x00/255, green: 0x4B/255, blue: 0xBD/255)       // OColor.blue600 (light)
            )
        }
    }
}

// MARK: - Helper Functions

private func formatTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "hh:mm a"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: date)
}

private func formatTimeRemaining(from now: Date, to target: Date) -> String {
    let diff = Int(target.timeIntervalSince(now))
    if diff <= 0 { return "" }
    let hours = diff / 3600
    let minutes = (diff % 3600) / 60
    if hours > 0 {
        return "\(hours) hr\(hours > 1 ? "s" : "") \(minutes) min"
    }
    return "\(minutes) min"
}

private func formatDateHeader() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"
    let day = Int(formatter.string(from: Date()))!
    let suffix: String
    switch day {
    case 1, 21, 31: suffix = "ST"
    case 2, 22: suffix = "ND"
    case 3, 23: suffix = "RD"
    default: suffix = "TH"
    }
    let monthFormatter = DateFormatter()
    monthFormatter.dateFormat = "MMMM"
    return "\(day)\(suffix) \(monthFormatter.string(from: Date()).uppercased())"
}

// MARK: - Widget Views

struct TimetableWidgetEntryView: View {
    var entry: TimetableEntry

    private var colors: WidgetColors {
        WidgetColors.colors(isDark: entry.isDark)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack(spacing: 6) {
                Text("Time Table")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(colors.titleText)
                Text("\u{2022}")
                    .foregroundColor(colors.dateText)
                Text(formatDateHeader())
                    .font(.system(size: 11))
                    .foregroundColor(colors.dateText)
                Spacer()
            }

            if entry.isWeekend {
                Spacer()
                HStack {
                    Spacer()
                    Text("Happy Weekend!")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(colors.courseNameText)
                    Spacer()
                }
                Spacer()
            } else if entry.noClasses {
                Spacer()
                HStack {
                    Spacer()
                    Text("No more classes today")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(colors.courseNameText)
                    Spacer()
                }
                Spacer()
            } else {
                HStack(spacing: 8) {
                    // Left card - current/next class
                    if let current = entry.currentClass {
                        leftCard(course: current)
                    }

                    // Right section - upcoming classes
                    if !entry.upcomingClasses.isEmpty {
                        VStack(spacing: 6) {
                            ForEach(0..<min(entry.upcomingClasses.count, 3), id: \.self) { index in
                                upcomingCard(course: entry.upcomingClasses[index])
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 2)
        .padding(.vertical, 4)
        .widgetBackground(colors.background)
    }

    @ViewBuilder
    private func leftCard(course: WidgetCourse) -> some View {
        let isOngoing = course.isOngoing
        let cardColor = isOngoing ? colors.ongoingCard : colors.upcomingCard
        let statusBg = isOngoing ? colors.statusOngoingBg : colors.statusUpcomingBg
        let timeColor = isOngoing ? colors.timeOngoing : colors.timeUpcoming

        VStack(alignment: .leading, spacing: 4) {
            // Status badge
            Text(isOngoing ? "ONGOING" : "UP NEXT")
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(statusBg)
                .cornerRadius(4)

            // Time remaining
            if !isOngoing {
                let remaining = formatTimeRemaining(from: Date(), to: course.startDate)
                if !remaining.isEmpty {
                    Text("in \(remaining)")
                        .font(.system(size: 11))
                        .foregroundColor(timeColor)
                }
            }

            // Course code
            Text(course.code)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(colors.titleText)
                .lineLimit(1)

            // Course name
            Text(course.course)
                .font(.system(size: 11))
                .foregroundColor(colors.courseNameText)
                .lineLimit(2)

            Spacer(minLength: 0)

            // Class time
            Text(course.timing)
                .font(.system(size: 10))
                .foregroundColor(colors.dateText)
        }
        .padding(10)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(cardColor)
        .cornerRadius(12)
    }

    @ViewBuilder
    private func upcomingCard(course: WidgetCourse) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(formatTime(course.startDate))
                .font(.system(size: 10))
                .foregroundColor(colors.dateText)
            Text(course.code)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(colors.titleText)
                .lineLimit(1)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(colors.innerCard)
        .cornerRadius(10)
    }
}

// MARK: - Background modifier for iOS 17+ compatibility

extension View {
    @ViewBuilder
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            self.containerBackground(color, for: .widget)
        } else {
            self.background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(color)
            )
        }
    }
}

// MARK: - Widget Configuration

struct TimetableWidget: Widget {
    let kind: String = "TimetableWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: TimetableProvider()) { entry in
            Link(destination: URL(string: entry.deeplink)!) {
                TimetableWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Time Table")
        .description("View your current and upcoming classes.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Food Widget

struct FoodEntry: TimelineEntry {
    let date: Date
    let mealName: String
    let mealItems: [String]
    let endTime: String
    let isDark: Bool
    let deeplink: String
}

struct FoodProvider: TimelineProvider {
    private let appGroupId = "group.com.swciitg.onestop2"

    func placeholder(in context: Context) -> FoodEntry {
        FoodEntry(date: Date(), mealName: "Lunch", mealItems: [], endTime: "", isDark: false, deeplink: "onestopiitg://home2?tab=1")
    }

    func getSnapshot(in context: Context, completion: @escaping (FoodEntry) -> Void) {
        completion(buildEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FoodEntry>) -> Void) {
        let entry = buildEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func buildEntry() -> FoodEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let isDark = defaults?.bool(forKey: "food_is_dark") ?? false
        let deeplink = defaults?.string(forKey: "food_deeplink") ?? "onestopiitg://home2?tab=1"
        let mealName = defaults?.string(forKey: "food_meal_name") ?? currentMealName()
        let endTime = defaults?.string(forKey: "food_end_time") ?? ""
        let itemsStr = defaults?.string(forKey: "food_meal_items") ?? ""
        let items = itemsStr.split(separator: "\n").map(String.init).filter { !$0.isEmpty }

        return FoodEntry(date: Date(), mealName: mealName, mealItems: items, endTime: endTime, isDark: isDark, deeplink: deeplink)
    }

    private func currentMealName() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let minute = Calendar.current.component(.minute, from: Date())
        if hour < 10 { return "Breakfast" }
        if hour < 14 || (hour == 14 && minute <= 30) { return "Lunch" }
        return "Dinner"
    }
}

struct FoodWidgetEntryView: View {
    var entry: FoodEntry

    private var colors: WidgetColors {
        WidgetColors.colors(isDark: entry.isDark)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Food")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(colors.titleText)

            if entry.mealItems.isEmpty {
                Text(entry.mealName.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.dateText)
                Spacer()
                Text("No menu data")
                    .font(.system(size: 12))
                    .foregroundColor(colors.dateText)
                Spacer()
            } else {
                let badge = entry.endTime.isEmpty
                    ? entry.mealName.uppercased()
                    : "\(entry.mealName.uppercased()) \u{2022} ENDS \(entry.endTime)"
                Text(badge)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(colors.dateText)

                Text(entry.mealItems.joined(separator: ", "))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(colors.titleText)
            }

            Spacer(minLength: 0)
        }
        .padding(4)
        .widgetBackground(colors.background)
    }
}

struct FoodWidget: Widget {
    let kind: String = "FoodWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FoodProvider()) { entry in
            Link(destination: URL(string: entry.deeplink)!) {
                FoodWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Food")
        .description("View current meal menu.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - GateLog Widget

struct GateLogEntry: TimelineEntry {
    let date: Date
    let isCheckedOut: Bool
    let destination: String
    let isDark: Bool
    let gateInfo: String
}

struct GateLogProvider: TimelineProvider {
    private let appGroupId = "group.com.swciitg.onestop2"

    func placeholder(in context: Context) -> GateLogEntry {
        GateLogEntry(date: Date(), isCheckedOut: false, destination: "", isDark: false, gateInfo: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (GateLogEntry) -> Void) {
        completion(buildEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<GateLogEntry>) -> Void) {
        let entry = buildEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func buildEntry() -> GateLogEntry {
        let defaults = UserDefaults(suiteName: appGroupId)
        let isDark = defaults?.bool(forKey: "gl_is_dark") ?? false
        let isCheckedOut = defaults?.bool(forKey: "gl_is_checked_out") ?? false
        let destination = defaults?.string(forKey: "gl_destination") ?? ""

        return GateLogEntry(date: Date(), isCheckedOut: isCheckedOut, destination: destination, isDark: isDark, gateInfo: computeGateInfo())
    }

    private func computeGateInfo() -> String {
        let now = Date()
        let cal = Calendar.current
        let hour = cal.component(.hour, from: now)
        let minute = cal.component(.minute, from: now)
        let totalMinutes = hour * 60 + minute

        let khokhaClose = 22 * 60
        let kvClose = 22 * 60 + 30

        let khokhaLeft = khokhaClose - totalMinutes
        let kvLeft = kvClose - totalMinutes

        if khokhaLeft > 0 {
            return "KHOKHA CLOSES IN \(formatRemaining(khokhaLeft))"
        } else if kvLeft > 0 {
            return "KV GATE CLOSES IN \(formatRemaining(kvLeft))"
        } else {
            return "ENTER VIA MAIN GATE"
        }
    }

    private func formatRemaining(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let mins = totalMinutes % 60
        var parts: [String] = []
        if hours > 0 { parts.append("\(hours) \(hours == 1 ? "HR" : "HRS")") }
        if mins > 0 { parts.append("\(mins) \(mins == 1 ? "MIN" : "MINS")") }
        return parts.joined(separator: " ")
    }
}

struct GateLogWidgetEntryView: View {
    var entry: GateLogEntry

    private var colors: WidgetColors {
        WidgetColors.colors(isDark: entry.isDark)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Gatelog")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(entry.isCheckedOut ? colors.statusOngoingBg : colors.titleText)

            if entry.isCheckedOut {
                // Checked-out state
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Check into Campus")
                            .font(.system(size: 13))
                            .foregroundColor(colors.courseNameText)

                        if !entry.gateInfo.isEmpty {
                            Text(entry.gateInfo)
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(colors.dateText)
                        }
                    }
                    Spacer()
                    Link(destination: URL(string: "onestopiitg://gatelog?autoCheckIn=true")!) {
                        Text("Check-In")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(colors.statusOngoingBg)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(entry.isDark ? Color(white: 0.23) : Color(red: 0xD1/255, green: 0xD2/255, blue: 0xD6/255), lineWidth: 1)
                            )
                    }
                }
                Spacer()
            } else {
                // Default state: 3 buttons with individual deep links
                Spacer()

                linkButton("To City", destination: "onestopiitg://gatelog?destination=City")
                linkButton("To Khokha", destination: "onestopiitg://gatelog?destination=Khokha")
                linkButton("Others", destination: "onestopiitg://gatelog?destination=Others")
            }
        }
        .padding(4)
        .widgetBackground(colors.background)
    }

    @ViewBuilder
    private func linkButton(_ title: String, destination: String) -> some View {
        Link(destination: URL(string: destination)!) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(colors.statusOngoingBg)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 7)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(entry.isDark ? Color(white: 0.23) : Color(red: 0xD1/255, green: 0xD2/255, blue: 0xD6/255), lineWidth: 1)
                )
        }
    }
}

struct GateLogWidget: Widget {
    let kind: String = "GateLogWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GateLogProvider()) { entry in
            GateLogWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Gatelog")
        .description("Quick checkout/checkin from home screen.")
        .supportedFamilies([.systemSmall])
    }
}

// MARK: - Widget Bundle

@main
struct OneStopWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimetableWidget()
        FoodWidget()
        GateLogWidget()
    }
}
