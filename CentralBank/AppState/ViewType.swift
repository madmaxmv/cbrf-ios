//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

import UIKit
import RxCocoa

/// Data-driven view.
protocol ViewType {
    /// Общий стейт приложения (системы).
    associatedtype StateStore
    /// Тип стейта данного view.
    associatedtype ViewState
    /// Установка стейта view.
    var state: Driver<ViewState>! { get set }
    /// Подписка на стейт приложения.
    func subscribe(to stateStore: StateStore)
}

extension ViewType where Self: UIViewController {

    mutating func bind(with stateStore: Self.StateStore) {
        loadViewIfNeeded()
        subscribe(to: stateStore)
    }
}
