//
//  ExchangeRatesTableSection.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import RxDataSources

enum RatesTableSection {
    case rates(items: [Item])
    
    enum Item {
        case rate(RateViewState)
    }
}

extension RatesTableSection: AnimatableSectionModelType, Equatable {

    var items: [Item] {
        switch self {
        case .rates(let items):
            return items
        }
    }
    
    var identity: Int {
        return "rates".hashValue
    }
    
    init(original: RatesTableSection, items: [RatesTableSection.Item]) {
        switch original {
        case .rates:
            self = .rates(items: items)
        }
    }
    
    public static func == (lhs: RatesTableSection, rhs: RatesTableSection) -> Bool {
        switch (lhs, rhs) {
        case let (.rates(lhs), .rates(rhs)):
            return lhs == rhs
        }
    }
}

extension RatesTableSection.Item: IdentifiableType, Equatable {
    
    var identity: Int {
        switch self {
        case .rate(let state):
            return state.model.code
        }
    }
    
    static func == (lhs: RatesTableSection.Item, rhs: RatesTableSection.Item) -> Bool {
        switch (lhs, rhs) {
        case let (.rate(lhs), .rate(rhs)):
            return lhs == rhs
        }
    }
}
