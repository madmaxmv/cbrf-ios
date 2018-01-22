//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift

struct TabBarViewState {

    /// Список доступных табов.
    var tabs: [TabItem] = []

    static var initial: TabBarViewState {
        return TabBarViewState()
    }

    init() {
        tabs = [
            .exchangeRates(index: 1,
                           title: NSLocalizedString("Rates", comment: "Курсы"),
                           icon: UIImage(),
                           selectedIcon: UIImage()
            )
        ]
    }
}

extension TabBarViewState: Equatable {
    public static func == (lhs: TabBarViewState, rhs: TabBarViewState) -> Bool {
        // Пока табы не изменяются, стейт всегда одинаков.
        return true
    }
}
