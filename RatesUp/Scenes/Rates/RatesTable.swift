//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

struct RatesTable {
    let items: [Item]
    enum Item {
        case rate(CurrencyDailyRate)
    }
}

extension RatesTable {
    final class Builder {
        var rates: [CurrencyDailyRate] = []

        func build(with change: (Builder) -> Void) -> RatesTable {
            change(self)
            return build()
        }
        
        func build() -> RatesTable {
            .init(items: rates.map(RatesTable.Item.rate))
        }
    }
}
