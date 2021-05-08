//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesSort {
    enum Policy {
        case standard
    }
    
    static func sort(for policy: Policy) -> (([CurrencyRate]) -> [CurrencyRate]) {
        switch policy {
        case .standard:
            return standardSort
        }
    }

    static func standardSort(rates: [CurrencyRate]) -> [CurrencyRate] {
        var allRates = rates
        var sortedRates: [CurrencyRate] = []
        if let usdIndex = allRates.firstIndex(where: { $0.characterCode == "USD" }) {
            sortedRates.append(allRates[usdIndex])
            allRates.remove(at: usdIndex)
        }

        if let eurIndex = allRates.firstIndex(where: { $0.characterCode == "EUR" }) {
            sortedRates.append(allRates[eurIndex])
            allRates.remove(at: eurIndex)
        }
        sortedRates.append(contentsOf: allRates.sorted(by: <))
        
        return sortedRates
    }
}
