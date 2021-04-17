//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class RatesViewController: UIViewController {

    private lazy var hosting = UIHostingController(rootView: ratesList)
    private let ratesList = RatesList()
    
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
        switch state.ratesResult {
        case .success(let rates):
            updateList(with: rates)
        default:
            break
        }
    }

    private func updateList(with rates: [CurrencyDailyRate]) {
        ratesList.updateList(with: rates)
    }
}

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}
