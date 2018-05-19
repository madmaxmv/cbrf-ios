//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxDataSources

enum СurrenciesTableSection {
    case included(items: [Item])
    case excluded(items: [Item])
    
    enum Item {
        case currency(CurrencyCell.State)
    }
}

extension СurrenciesTableSection: AnimatableSectionModelType {
    
    var items: [Item] {
        switch self {
        case .included(let items),
             .excluded(let items):
            return items
        }
    }
    
    var identity: Int {
        switch self {
        case .included:
            return "included".hashValue
        case .excluded:
            return "excluded".hashValue
        }
    }

    init(original: СurrenciesTableSection, items: [СurrenciesTableSection.Item]) {
        switch original {
        case .included: self = .included(items: items)
        case .excluded: self = .excluded(items: items)
        }
    }
}

extension СurrenciesTableSection: Equatable {
    static func == (lhs: СurrenciesTableSection, rhs: СurrenciesTableSection) -> Bool {
        switch (lhs, rhs) {
        case let (.included(lhs), .included(rhs)),
             let (.excluded(lhs), .excluded(rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}

extension СurrenciesTableSection.Item: IdentifiableType, Equatable {
    
    var identity: Int {
        switch self {
        case .currency(let state):
            return state.characterCode.hashValue
        }
    }
    
    static func == (lhs: СurrenciesTableSection.Item, rhs: СurrenciesTableSection.Item) -> Bool {
        switch (lhs, rhs) {
        case let (.currency(lhs), .currency(rhs)):
            return lhs == rhs
        }
    }
}
