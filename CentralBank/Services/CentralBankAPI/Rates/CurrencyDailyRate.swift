//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import SWXMLHash

struct CurrencyDailyRate {
    /// Уникальный идентификатор валюты.
    let id: String
    /// Численный код валюты.
    let code: String
    /// Символьное обозначение валюты. Например USD.
    let characterCode: String
    /// Номинал валюты.
    let nominal: Int
    /// Название валюты.
    let name: String
    /// Валютная ставка в рублях.
    let value: Double
}

extension CurrencyDailyRate: XMLDecodable {
    init(xml: XMLIndexer) {
        id = xml.element!.attribute(by: "ID")!.text
        code = xml["NumCode"].element!.text
        characterCode = xml["CharCode"].element!.text
        nominal = Int(xml["Nominal"].element!.text)!
        name = xml["Name"].element!.text
        value = Double(xml["Value"].element!.text.replacingOccurrences(of: ",", with: "."))!
    }
}
