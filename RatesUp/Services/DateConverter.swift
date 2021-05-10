//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

/// Конвертер, который умеет преобраховывать дату, удаляя из нее смещение по времени.
public class DateConverter {
    /// Календарь для конвертации даты.
    private var _calendar: Calendar
    private let utc = TimeZone(abbreviation: "UTC")!

    public init(calendar: Calendar) {
        _calendar = calendar
    }

    public static let gregorian: DateConverter = {
        return DateConverter(calendar: Calendar(identifier: .gregorian))
    }()

    public func date(removedTimeOffsetFor date: Date,
                     in timeZone: TimeZone = .current) -> Date {
        _calendar.timeZone = timeZone
        let components = _calendar.dateComponents([.day, .month, .year], from: date)

        _calendar.timeZone = utc
        guard let convertedDate = _calendar.date(from: components) else {
            assertionFailure("Could not create date with components: \(components).")
            return date
        }
        return convertedDate
    }
}
