//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct RatesView: View {

    class StateObject: ObservableObject {
        @Published var isLoading = false
        @Published var rates: [RateCell.State] = []
    }

    @ObservedObject var stateObject = StateObject()

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

extension EdgeInsets {
    static let standard = EdgeInsets(
        top: 8, leading: 12, bottom: 8, trailing: 12
    )
}
