//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxDataSources

struct RatesSection: Equatable {
    enum Item: Equatable {
        case rate(code: Int, state: RateCell.State)
    }

    let items: [Item]
    init(items: [Item]) {
        self.items = items
    }
}

extension RatesSection: AnimatableSectionModelType {
    var identity: Int { "rates".hashValue }

    init(original: RatesSection, items: [RatesSection.Item]) {
        self.items = items
    }
}

extension RatesSection.Item: IdentifiableType {
    var identity: Int {
        switch self {
        case .rate(let code, _):
            return code
        }
    }
}

extension RatesSection {
    typealias Converter = (RatesTable) -> [RatesSection]
    static func converter(table: RatesTable) -> [RatesSection] {
        return [
            RatesSection(items: table.items
                .map { item in
                    switch item {
                    case .rate(let state):
                        return rateConverter(rate: state)
                    }
                }
            )
        ]
    }

    static func rateConverter(rate: CurrencyDailyRate) -> RatesSection.Item {
        return .rate(
            code: rate.code,
            state: RateCell.State(
                flag: rate.flag.emoji,
                characterCode: rate.characterCode,
                details: "\(rate.nominal) \(rate.currencyName)",
                value: String(rate.value),
                difference: rateDifference(rate: rate)
            )
        )
    }

    static func rateDifference(rate: CurrencyDailyRate) -> RateCell.State.Difference? {
        switch rate.difference {
        case .some(let diff) where diff > 0:
            return .init(
                title: String(format: "%.5f", diff),
                color: .green
            )
        case .some(let diff) where diff < 0:
            return .init(
                title: String(format: "%.5f", diff),
                color: .red
            )
        default:
            return nil
        }
    }
}

import RxSwift
import RxCocoa
import RxOptional

struct RatesSectionsProvider {
    typealias Table = [RatesSection]
    let sections = BehaviorSubject<Table>(value: [])
    private let converter: RatesSection.Converter
    private let builder = RatesTable.Builder()
    private let bag = DisposeBag()
    
    init(converter: @escaping RatesSection.Converter) {
        self.converter = converter
    }

    func subscribe(to store: AppStore) {
        store.state.map(\.rates.ratesResult)
            .map { $0?.rates }
            .filterNil()
            .map { [builder] rates in builder
                .build(with: { $0.rates = rates }) }
            .map { self.converter($0) }
            .bind(onNext: { self.sections.onNext($0) })
            .disposed(by: bag)
    }
}
