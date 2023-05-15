// Created by Bryan Keller on 6/18/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

import HorizonCalendar
import UIKit

// MARK: - DemoViewController

protocol CalenderProtocolViewController: UIViewController {

  init(monthsLayout: MonthsLayout)

  var calendar: Calendar { get }
  var monthsLayout: MonthsLayout { get }

}

// MARK: - BaseDemoViewController

class CalenderBaseViewController: UIViewController, CalenderProtocolViewController {

  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    self.monthsLayout = monthsLayout

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let monthsLayout: MonthsLayout
   
  lazy var calendarView = CalendarView(initialContent: makeContent())
  lazy var calendar = Calendar.current
    var selectedDayRange: DayRange?
  lazy var dayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "EEEE, MMM d, yyyy",
      options: 0,
      locale: calendar.locale ?? Locale.current)
    return dateFormatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
  }

    //MARK: - Calender Content
    
     func makeContent() -> CalendarViewContent {
        let startDate = calendar.date(from: DateComponents(year: 2022, month: 01, day: 01))!
        let endDate = Date()
        
        let dateRanges: Set<ClosedRange<Date>>
        let selectedDayRange = selectedDayRange
        if
            let selectedDayRange,
            let lowerBound = calendar.date(from: selectedDayRange.lowerBound.components),
            let upperBound = calendar.date(from: selectedDayRange.upperBound.components)
        {
            dateRanges = [lowerBound...upperBound]
        } else {
            dateRanges = []
        }
        
        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startDate...endDate,
            monthsLayout: monthsLayout)
        
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        
        .dayItemProvider { [calendar, dayDateFormatter] day in
            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive
            
            let isSelectedStyle: Bool
            if let selectedDayRange {
                isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
            } else {
                isSelectedStyle = false
            }
            
            if isSelectedStyle {
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .black
                invariantViewProperties.backgroundShapeDrawingConfig.borderColor = .black
                invariantViewProperties.textColor = .white
            }
            
            let date = calendar.date(from: day.components)
            
            return DayView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(
                    dayText: "\(day.day)",
                    accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                    accessibilityHint: nil))
        }
        
        .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in

            DayRangeIndicatorView.calendarItemModel(
                invariantViewProperties: .init(indicatorColor:UIColor(hexString: "B5B9CC",alpha: 0.2)),
                content: .init(
                    framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
    }
    

}

// MARK: NSLayoutConstraint + Priority Helper

extension NSLayoutConstraint {

  fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }

}
