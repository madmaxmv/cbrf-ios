//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

typealias RatesStateStore = Store<
    RatesState,
    RatesEvent,
    RatesEnvironment
>

struct RatesState: Equatable {

    var isLoading: Bool = false
    var ratesResult: RatesResult?

    static let initial = RatesState()
}

enum RatesEvent {
    case initial
    case ratesResult(RatesResult)
    case openRate(withID: String)
    case nothing
}
