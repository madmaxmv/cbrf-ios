//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

final class CurrencyRateViewController: UIViewController {

    private let currencyRateView = CurrencyRateView()
    private lazy var hosting = UIHostingController(
        rootView: currencyRateView
    )

    private let store: CurrencyRateStore
    private var subscriptions: Set<AnyCancellable> = []

    init(store: CurrencyRateStore) {
        self.store = store
        super.init(nibName: nil, bundle: nil)

        setHostingController(hosting)
        subscribe(to: store)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        store.send(.loadDynamics)
    }

    func subscribe(to store: CurrencyRateStore) {
        store.state
            .map(\.currencyRate)
            .removeDuplicates()
            .sink { [weak self] currencyRate in
                self?.render(currencyRate)
            }
            .store(in: &subscriptions)
    }

    func render(_ currencyRate: CurrencyRate) {
        currencyRateView.render(
            currencyState: mapRate(currencyRate)
        )
    }

    private func mapRate(_ rate: CurrencyRate) -> CurrencyRateView.CurrencyState {
        return CurrencyRateView.CurrencyState(
            icon: rate.flag.emoji,
            code: rate.characterCode,
            details: "\(rate.nominal) \(rate.currencyName)",
            value: String(rate.value)
        )
    }
}
