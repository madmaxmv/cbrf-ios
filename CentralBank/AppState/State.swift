//
//  Copyright © 2017 Tutu.tu. All rights reserved.
//

/// Модель состояния.
protocol State {

    /// События характерные для данного состояния.
    associatedtype Event

    /// Reducer состояния.
    static func reduce(state: Self, event: Event) -> Self
}
