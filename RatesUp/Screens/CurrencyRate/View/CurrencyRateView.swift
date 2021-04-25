//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct CurrencyRateView: View {

    class StateObject: ObservableObject {
        @Published var currencyState: CurrencyState? = nil
    }
    @ObservedObject private var stateObject = StateObject()
    
    var body: some View {
        
        if let currencyState = stateObject.currencyState {
            VStack {
                Text(currencyState.icon)
                    .font(.system(size: 120))
                    .padding(40)
                
                Text(currencyState.code)
                    .font(.title)

                Text(currencyState.details)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                    .padding(4)
                
                Spacer()
            }
        } else {
            ActivityIndicator()
        }
    }
}

extension CurrencyRateView {

    struct CurrencyState {
        let icon: String
        let code: String
        let details: String
        let value: String

        static let mock = CurrencyState(
            icon: "🇺🇸",
            code: "USD",
            details: "1 USA dollar",
            value: "76.0000"
        )
    }

    @discardableResult
    func render(currencyState: CurrencyState) -> CurrencyRateView {
        stateObject.currencyState = currencyState
        return self
    }
}

struct CurrencyRateView_Preview: PreviewProvider {

    static var previews: some View {
        CurrencyRateView()
            .render(currencyState: .mock)
    }
}
