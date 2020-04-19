//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RatesSort {
    enum Policy {
        case standard
    }
    
    static func sort(for policy: Policy) -> (([CurrencyDailyRate]) -> [CurrencyDailyRate]) {
        switch policy {
        case .standard:
            return standartSort
        }
    }

    static func standartSort(rates: [CurrencyDailyRate]) -> [CurrencyDailyRate] {
        var allRates = rates
        var sortedRates: [CurrencyDailyRate] = []
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
