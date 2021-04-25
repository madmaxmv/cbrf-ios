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

    private let store: RatesStateStore
    private var subscriptions: Set<AnyCancellable> = []

    init(store: RatesStateStore) {
        self.store = store
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

    override func viewDidLoad() {
        super.viewDidLoad()

        store.send(.initial)
    }

    func subscribe(to store: RatesStateStore) {
        store.state
            .sink { [weak self] state in
                self?.render(state: state)
            }
            .store(in: &subscriptions)

        ratesView.events
            .sink { event in
                switch event {
                case .didTapRate(let id):
                    store.send(.openRate(withID: id))
                }
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
                        id: $0.id,
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
