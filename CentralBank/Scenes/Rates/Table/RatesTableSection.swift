//
//  ExchangeRatesTableSection.swift
//  CentralBank
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import RxDataSources

enum RatesTableSection {
    case rates(items: [Item])
    
    enum Item {
        case rate
    }
}
