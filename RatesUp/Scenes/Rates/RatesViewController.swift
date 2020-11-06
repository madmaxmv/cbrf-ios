//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa
import RxOptional

class RatesViewController: UIViewController, UITableViewDelegate {

    private let ratesList = RatesList()
    private lazy var hosting = UIHostingController(rootView: ratesList)
    
    private let editItem = update(
        UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: nil)
    ) {
        $0.tintColor = .mainText
    }
    
    private let refreshControl = update(UIRefreshControl()) {
        $0.tintColor = .activity
    }

    private let bag = DisposeBag()
    
    init(store: AppStore) {
        super.init(nibName: nil, bundle: nil)

        navigationItem.rightBarButtonItem = editItem

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
        let ratesState = store.state.map(\.rates)
            .distinctUntilChanged()

        ratesState
            .map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: bag)

        ratesState
            .map { $0.ratesResult?.rates }
            .filterNil()
            .distinctUntilChanged()
            .bind(onNext: { [weak self] in self?.updateList(with: $0)} )
            .disposed(by: bag)
        
        // Events
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { .rates(.refreshRates) }
            .bind(onNext: { store.send($0) })
            .disposed(by: bag)
    }

    private func updateList(with rates: [CurrencyDailyRate]) {
        ratesList.updateList(with: rates)
    }
}

fileprivate extension RatesState {
    var isLoading: Bool { ratesResult == nil }
}

extension UIView {
    func addSubview(_ view: UIView, constraints: [NSLayoutConstraint]) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate(constraints)
    }
}
