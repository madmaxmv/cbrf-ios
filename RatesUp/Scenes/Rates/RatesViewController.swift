//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class RatesViewController: UIViewController {

    private let ratesView = RatesView()
    private lazy var hosting = UIHostingController(
        rootView: ratesView
    )

    private var subscriptions: Set<AnyCancellable> = []

    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)

        addChild(hosting)
        view.addSubview(hosting.view, constraints: [
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        hosting.didMove(toParent: self)

        subscribe(to: store)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribe(to store: AppStore) {
        store.state
            .map(\.rates)
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &subscriptions)
    }

    private func render(state: RatesState) {
        ratesView.render(state: mapState(state))
    }

    private func mapState(_ state: RatesState) -> RatesView.State {
        switch state.ratesResult {
        case nil:
            return RatesView.State(
                isLoading: true,
                rates: []
            )
        case let .success(dailyRates):
            return RatesView.State(
                isLoading: false,
                rates: dailyRates.rates.map {
                    RateCell.State(
                        flag: $0.flag.emoji,
                        characterCode: $0.characterCode,
                        details: "\($0.nominal) \($0.currencyName)",
                        value: String($0.value)
                    )
                }
            )
        case .failure:
            return RatesView.State(
                isLoading: false,
                rates: []
            )
        }
    }
}

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}
