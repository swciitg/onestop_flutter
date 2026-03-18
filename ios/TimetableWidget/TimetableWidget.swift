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
            deeplink: "onestopiitg://home2",
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
        let deeplink = defaults?.string(forKey: "tt_deeplink") ?? "onestopiitg://home2"

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
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "hh:mm - hh:mm a"

        guard let parsed = formatter.date(from: timing) else { return nil }

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

    static func colors(isDark: Bool) -> WidgetColors {
        if isDark {
            return WidgetColors(
                background: Color(red: 0x1E/255, green: 0x20/255, blue: 0x2D/255),
                innerCard: Color(red: 0x16/255, green: 0x18/255, blue: 0x22/255),
                ongoingCard: Color(red: 0x2D/255, green: 0x40/255, blue: 0x35/255),
                upcomingCard: Color(red: 0x01/255, green: 0x21/255, blue: 0x51/255),
                titleText: Color(red: 0xFF/255, green: 0xFD/255, blue: 0xFC/255),
                dateText: Color(red: 0x6F/255, green: 0x6F/255, blue: 0x6F/255),
                courseNameText: Color(red: 0x9B/255, green: 0x9B/255, blue: 0x9B/255),
                statusOngoingBg: Color(red: 0x4C/255, green: 0xAF/255, blue: 0x50/255),
                statusUpcomingBg: Color(red: 0x1E/255, green: 0x88/255, blue: 0xE5/255),
                timeOngoing: Color(red: 0x38/255, green: 0x8E/255, blue: 0x3C/255),
                timeUpcoming: Color(red: 0x1E/255, green: 0x88/255, blue: 0xE5/255)
            )
        } else {
            return WidgetColors(
                background: Color.white,
                innerCard: Color(red: 0xF4/255, green: 0xF5/255, blue: 0xF5/255),
                ongoingCard: Color(red: 0xDC/255, green: 0xEF/255, blue: 0xE4/255),
                upcomingCard: Color(red: 0xD6/255, green: 0xE6/255, blue: 0xFF/255),
                titleText: Color.black,
                dateText: Color(red: 0x98/255, green: 0x99/255, blue: 0x9F/255),
                courseNameText: Color(red: 0x6E/255, green: 0x6F/255, blue: 0x77/255),
                statusOngoingBg: Color(red: 0x4C/255, green: 0xAF/255, blue: 0x50/255),
                statusUpcomingBg: Color(red: 0x1E/255, green: 0x88/255, blue: 0xE5/255),
                timeOngoing: Color(red: 0x38/255, green: 0x8E/255, blue: 0x3C/255),
                timeUpcoming: Color(red: 0x1E/255, green: 0x88/255, blue: 0xE5/255)
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
        .padding(14)
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
            TimetableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Time Table")
        .description("View your current and upcoming classes.")
        .supportedFamilies([.systemMedium])
    }
}

// MARK: - Widget Bundle

@main
struct TimetableWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimetableWidget()
    }
}
