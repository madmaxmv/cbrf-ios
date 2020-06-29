//
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
        differenceLabel.text = state.difference?.title
        
        switch state.difference?.color {
        case .red:
            differenceLabel.textColor = .red
        case .green:
            differenceLabel.textColor = .green
        case nil:
            break
        }
    }
}

extension RateCell {
    struct State: Equatable {
        let flag: String
        let characterCode: String
        let details: String
        let value: String
        let difference: Difference?

        struct Difference: Equatable {
            let title: String
            let color: Color

            enum Color {
                case red, green
            }
        }
    }
}
