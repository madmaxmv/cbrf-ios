//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Combine
import SwiftUI
import SwiftUICharts

struct CurrencyRateView: View {

    class StateObject: ObservableObject {
        @Published var currencyState: CurrencyState?
        @Published var dynamicsState: DynamicsState?
    }
    @ObservedObject private var stateObject = StateObject()
    private var eventPublisher = PassthroughSubject<Event, Never>()

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

                if let dynamicsState = stateObject.dynamicsState {
                    LineView(
                        data: dynamicsState.values,
                        style: Styles.barChartStyleNeonBlueLight
                    ).padding(20)
                }

                Spacer()

                Button("Done") { eventPublisher.send(.didTapDone) }
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

    struct DynamicsState {
        let values: [Double]
    }

    @discardableResult
    func render(currencyState: CurrencyState) -> CurrencyRateView {
        stateObject.currencyState = currencyState
        return self
    }

    @discardableResult
    func render(dynamicsState: DynamicsState) -> CurrencyRateView {
        stateObject.dynamicsState = dynamicsState
        return self
    }
}

extension CurrencyRateView {

    enum Event {
        case didTapDone
    }

    var events: AnyPublisher<Event, Never> {
        eventPublisher.eraseToAnyPublisher()
    }
}

struct CurrencyRateViewPreview: PreviewProvider {

    static var previews: some View {
        CurrencyRateView()
            .render(currencyState: .mock)
    }
}
