//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesViewState {

    /// Показывает процесс загрузки.
    var isLoading: Bool = true
    /// Содержимое таблицы.
    var content: [RatesTableSection] = []
    
    static var initial: RatesViewState {
        return RatesViewState()
    }
}


extension RatesViewState: Equatable {
    public static func == (lhs: RatesViewState, rhs: RatesViewState) -> Bool {
        return lhs.isLoading == rhs.isLoading
            && lhs.content == rhs.content
    }
}
