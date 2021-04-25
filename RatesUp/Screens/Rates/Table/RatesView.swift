//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import SwiftUI
import Combine

struct RatesView: View {

    class StateObject: ObservableObject {
        @Published var isLoading = false
        @Published var rates: [RateCell.State] = []
    }

    @ObservedObject private var stateObject = StateObject()
    private var eventPublisher = PassthroughSubject<Event, Never>()

    init() {
        UINavigationBar.appearance().backgroundColor = .white
    }

    var body: some View {
        NavigationView {
            Group {
                if stateObject.isLoading {
                    ActivityIndicator(style: .large)
                } else {
                    ScrollView([.vertical]) {
                        LazyVStack(spacing: 12) {
                            ForEach(stateObject.rates) { rate in
                                RateCell(state: rate)
                                    .onTapGesture {
                                        eventPublisher.send(.didTapRate(withID: rate.id))
                                    }
                            }
                        }
                        .padding([.top, .bottom], 16)
                    }
                    .background(
                        Color.gray.opacity(0.1)
                            .edgesIgnoringSafeArea(.bottom)
                    )
                }
            }
            .navigationBarTitle("Currency rates")
        }
    }
}

// MARK: - State
extension RatesView {

    struct State {
        let isLoading: Bool
        let rates: [RateCell.State]
    }

    func render(state: State) {
        stateObject.isLoading = state.isLoading
        stateObject.rates = state.rates
    }
}

extension RatesView {

    enum Event {
        case didTapRate(withID: String)
    }

    var events: AnyPublisher<Event, Never> {
        eventPublisher.eraseToAnyPublisher()
    }
}

extension EdgeInsets {
    static let standard = EdgeInsets(
        top: 8, leading: 12, bottom: 8, trailing: 12
    )
}
