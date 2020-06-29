//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct CurrenciesViewState: Equatable {

    /// Модель для отображения в теблице.
    var dataSource: [СurrenciesTableSection] = []

    mutating func set(currencies: [Currency]) {
        var included: [СurrenciesTableSection.Item] = []
        var excluded: [СurrenciesTableSection.Item] = []
        
        currencies.forEach {
            let emoji = (Flag(rawValue: $0.characterCode) ?? .unknown).emoji
            if $0.isIncluded {
                included.append(.currency(.init(flag: emoji,
                                                characterCode: $0.characterCode,
                                                action: .delete)))
            } else {
                excluded.append(.currency(.init(flag: emoji,
                                                characterCode: $0.characterCode,
                                                action: .add)))
            }
        }
        dataSource = [
            .included(items: included),
            .excluded(items: excluded)
        ]
    }
    
    static var initial: CurrenciesViewState {
        return CurrenciesViewState()
    }
}
