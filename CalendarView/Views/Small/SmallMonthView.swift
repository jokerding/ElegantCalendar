// Kevin Li - 7:16 PM - 6/13/20

import SwiftUI

struct SmallMonthView: View, CalendarManagerDirectAccess {

    @EnvironmentObject var calendarManager: ElegantCalendarManager

    let month: Date

    private var weeks: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: month) else {
            return []
        }
        return generateDates(
            inside: monthInterval,
            matching: calendar.firstDayOfEveryWeek)
    }

    private var isWithinSameMonthAndYearAsToday: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularities: [.month, .year])
    }

    private var isWithinDateRange: Bool {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.month, .year], from: month))!
        let startOfStartDate = calendar.date(from: calendar.dateComponents([.month, .year], from: startDate))!
        let startOfEndDate = calendar.date(from: calendar.dateComponents([.month, .year], from: endDate))!
        return startOfMonth >= startOfStartDate && startOfMonth <= startOfEndDate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            monthText
            weeksViewStack
                .frame(height: CalendarConstants.Yearly.daysStackHeight)
        }
        .frame(width: CalendarConstants.Yearly.monthWidth)
        .contentShape(Rectangle())
        .opacity(isWithinDateRange ? 1 : 0)
        .onTapGesture(perform: currentMonthSelected)
    }

    private var monthText: some View {
        Text(month.abbreviatedMonth.uppercased())
            .font(.subheadline)
            .bold()
            .foregroundColor(isWithinSameMonthAndYearAsToday ? themeColor : .white)
    }

    private var weeksViewStack: some View {
        VStack(spacing: CalendarConstants.Yearly.daysGridVerticalSpacing) {
            ForEach(weeks, id: \.self) { week in
                SmallWeekView(week: week)
            }
            if weeks.count == 5 {
                Spacer()
            }
        }
    }

    private func currentMonthSelected() {
        smallCalendarManager.monthTapped(month)
    }

}

struct SmallMonthView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarManagerGroup {
            DarkThemePreview {
                SmallMonthView(month: Date())
            }

            DarkThemePreview {
                SmallMonthView(month: .daysFromToday(45))
            }

            DarkThemePreview {
                SmallMonthView(month: .daysFromToday(-30))
            }
        }
    }
}
