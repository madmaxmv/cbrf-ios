//
//  RateViewState.swift
//  CentralBank
//
//  Created by Максим on 21/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation

struct RateViewState {
    let characterCode: String
    let details: String
    let value: String
    let difference: String
    
    let model: RateModel
    
    init(model: RateModel) {
        self.model = model
        
        characterCode = model.characterCode
        details = "\(model.nominal) \(model.currencyName)"
        value = String(model.value)
        difference = String(model.difference)
    }
}

extension RateViewState: Equatable {
    public static func == (lhs: RateViewState, rhs: RateViewState) -> Bool {
        return lhs.characterCode == rhs.characterCode
            && lhs.details == rhs.details
            && lhs.value == rhs.value
            && lhs.difference == rhs.difference
    }
}
