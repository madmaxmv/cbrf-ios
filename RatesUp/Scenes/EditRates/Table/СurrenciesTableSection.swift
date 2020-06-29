//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxDataSources

enum СurrenciesTableSection: Equatable {
    case included(items: [Item])
    case excluded(items: [Item])
    
    enum Item: Equatable {
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

extension СurrenciesTableSection.Item: IdentifiableType {
    
    var identity: Int {
        switch self {
        case .currency(let state):
            return state.characterCode.hashValue
        }
    }
}
