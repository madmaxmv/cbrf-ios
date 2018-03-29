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
    
    /// Конвертер для григорианского календаряю.
    public static let gregorian: DateConverter = {
        return DateConverter(calendar: Calendar(identifier: .gregorian))
    }()
    
    /// Метод возвращает дату без смещения по времени.
    /// Например: "2018-02-20 ??:??:?? +000" перобразует в "2018-02-20 00:00:00 +0000"
    /// - parameters:
    ///     - date: дата для которой необходимо убрать время.
    ///     - timeZone: тайм зона в которой необходимо получить дату без времени.
    ///
    ///  Пример использования в котором для дат указан .description, для timeZone - смещение относительно UTC:
    ///  (Переданная дата будет смещена на +3 часа и из нее удалено время)
    ///
    ///     removeTimeOffset(date: "2018-02-19 23:55:19 +0000", timeZone: "+0300") -> "2018-02-20 00:00:00 +0000"
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
