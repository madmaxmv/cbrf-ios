//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct CurrenciesViewState {
 
    static var initial: CurrenciesViewState {
        return CurrenciesViewState()
    }
}

extension CurrenciesViewState: Equatable {
    static func ==(lhs: CurrenciesViewState, rhs: CurrenciesViewState) -> Bool {
        return true
    }
}
