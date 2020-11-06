//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct RatesList: View {

    class State: ObservableObject {
        @Published var rates: [RateCell.State] = []
    }

    @ObservedObject var state = State()

    var body: some View {
        List {
            ForEach(state.rates) { state in
                RateCell(state: state)
            }
            .listRowInsets(.standard)
        }
    }

    func updateList(with rates: [CurrencyDailyRate]) {
        state.rates = rates.map {
            RateCell.State(
                flag: $0.flag.emoji,
                characterCode: $0.characterCode,
                details: "\($0.nominal) \($0.currencyName)",
                value: String($0.value)
            )
        }
    }
}

extension EdgeInsets {
    static let standard = EdgeInsets(
        top: 8, leading: 12, bottom: 8, trailing: 12
    )
}
