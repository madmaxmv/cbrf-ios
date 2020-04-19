//
//  RateCell.swift
//  RatesUp
//
//  Created by Максим on 20/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    @IBOutlet weak var flagLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var differenceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        codeLabel.textColor = .mainText
        detailsLabel.textColor = .secondaryText
        contentView.addSeparator()
    }
    
    func setup(with state: State) {
        flagLabel.text = state.flag
        codeLabel.text = state.characterCode
        detailsLabel.text = state.details
        valueLabel.text = state.value
        differenceLabel.text = state.difference
        differenceLabel.textColor = state.differenceColor
    }
}

extension RateCell {
    struct State {
        let flag: String
        let characterCode: String
        let details: String
        let value: String
        
        let difference: String?
        let differenceColor: UIColor
        
        let model: CurrencyDailyRate
        
        init(model: CurrencyDailyRate) {
            self.model = model
            flag = model.flag.emoji
            characterCode = model.characterCode
            details = "\(model.nominal) \(model.currencyName)"
            value = String(model.value)
            
            switch model.difference {
            case .some(let diff) where diff > 0:
                difference = String(format: "%.5f", diff)
                differenceColor = .green
            case .some(let diff) where diff < 0:
                difference = String(format: "%.5f", diff)
                differenceColor = .red
            default:
                difference = nil
                differenceColor = .clear
            }
        }
    }
}

extension RateCell.State: Equatable {
    public static func == (lhs: RateCell.State, rhs: RateCell.State) -> Bool {
        return lhs.characterCode == rhs.characterCode
            && lhs.details == rhs.details
            && lhs.value == rhs.value
            && lhs.difference == rhs.difference
    }
}

