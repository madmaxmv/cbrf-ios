//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

class CurrencyCell: UITableViewCell {
    
    private let _actionButton = UIButton()
    private let _flagLabel = UILabel()
    private let _currencyLabel = UILabel()
    private let _dragAndDropButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.addSeparator()
        
        addSubview(_currencyLabel)
        _currencyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _currencyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            _currencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            _currencyLabel.heightAnchor.constraint(equalToConstant: 20)
            ])
        
        addSubview(_flagLabel)
        _flagLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            _flagLabel.centerYAnchor.constraint(equalTo: _currencyLabel.centerYAnchor),
            _flagLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            _flagLabel.rightAnchor.constraint(equalTo: _currencyLabel.leftAnchor, constant: -4),
            ])

        addSeparator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with state: State) {
        _flagLabel.text = state.flag
        _currencyLabel.text = state.characterCode
    }
}

extension CurrencyCell {
    enum ActionType: Equatable {
        case delete, add
    }

    struct State: Equatable {
        let flag: String
        let characterCode: String
        let action: ActionType
    }
}
