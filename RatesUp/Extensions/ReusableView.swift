//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

protocol ReusableView {}

extension ReusableView where Self: UIView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

public protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView, NibLoadableView {}

extension UITableView {
    func register<Cell: UITableViewCell>(_ : Cell.Type){
        register(UINib(nibName: Cell.nibName, bundle: nil),
                 forCellReuseIdentifier: Cell.reusableIdentifier)
    }
    
    func register<Cell: UITableViewCell>(class: Cell.Type){
        register(`class`, forCellReuseIdentifier: Cell.reusableIdentifier)
    }
    
    func dequeueCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: Cell.reusableIdentifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue cell with \(Cell.reusableIdentifier)")
        }
        return cell
    }
}
