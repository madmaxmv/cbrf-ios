//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RateModel {
    let flag: Flag
    let code: Int
    let characterCode: String
    let currencyName: String
    let nominal: Int
    let value: Double
    let difference: Double
}

extension RateModel {
    init(apiModel: CurrencyDailyRate) {
        flag = Flag(rawValue: apiModel.characterCode) ?? .unknown
        code = Int(apiModel.code) ?? 0
        characterCode = apiModel.characterCode
        currencyName = apiModel.name
        nominal = apiModel.nominal
        value = apiModel.value
        difference = 0.0
    }
}

enum Flag: String {
    case AUD
    case AZN
    case GBP
    case AMD
    case BYN
    case BGN
    case BRL
    case HUF
    case HKD
    case DKK
    case USD
    case EUR
    case INR
    case KZT
    case CAD
    case KGS
    case CNY
    case MDL
    case NOK
    case PLN
    case RON
    case XDR
    case SGD
    case TJS
    case TRY
    case TMT
    case UZS
    case UAH
    case CZK
    case SEK
    case CHF
    case ZAR
    case KRW
    case JPY
    case unknown

    var emoji: String {
        switch self {
        case .AUD: return "🇦🇺"
        case .AZN: return "🇦🇿"
        case .GBP: return "🇬🇧"
        case .AMD: return "🇦🇲"
        case .BYN: return "🇧🇾"
        case .BGN: return "🇧🇬"
        case .BRL: return "🇧🇷"
        case .HUF: return "🇭🇺"
        case .HKD: return "🇭🇰"
        case .DKK: return "🇩🇰"
        case .USD: return "🇺🇸"
        case .EUR: return "🇪🇺"
        case .INR: return "🇮🇳"
        case .KZT: return "🇰🇿"
        case .CAD: return "🇨🇦"
        case .KGS: return "🇰🇬"
        case .CNY: return "🇨🇳"
        case .MDL: return "🇲🇩"
        case .NOK: return "🇳🇴"
        case .PLN: return "🇵🇱"
        case .RON: return "🇷🇴"
        case .XDR: return "🏳️"
        case .SGD: return "🇸🇬"
        case .TJS: return "🇹🇯"
        case .TRY: return "🇹🇷"
        case .TMT: return "🇹🇲"
        case .UZS: return "🇺🇿"
        case .UAH: return "🇺🇦"
        case .CZK: return "🇨🇿"
        case .SEK: return "🇸🇪"
        case .CHF: return "🇨🇭"
        case .ZAR: return "🇿🇦"
        case .KRW: return "🇰🇷"
        case .JPY: return "🇯🇵"
        case .unknown: return ""
        }
    }
}

