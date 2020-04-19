//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

/// Модель состояния.
protocol State {

    /// События характерные для данного состояния.
    associatedtype Event

    /// Reducer состояния.
    mutating func reduce(event: Event)
}
