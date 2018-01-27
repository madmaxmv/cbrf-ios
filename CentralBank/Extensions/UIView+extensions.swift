//
//  UIView+extensions.swift
//  CentralBank
//
//  Created by Максим on 27/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import UIKit

extension UIView {
    /// Определяет сторону вью
    enum Side {
        case top, bottom, leading, trailing
    }
    
    /// Добавляет сепаратор к вью.
    @discardableResult
    func addSeparator(side: Side = .bottom,
                             thikness: CGFloat = 0.5,
                             color: UIColor = .separator) -> UIView {
        // Линии шириной меньше единицы не будут отображаться на неретине, поэтому сделаем их 1
        let thikness = UIScreen.main.scale < 1.9 ? max(1, thikness) : thikness
        
        let separator = UIView()
        separator.backgroundColor = color
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: thikness).isActive = true
        if side != .bottom {
            separator.topAnchor.constraint(equalTo: topAnchor).isActive = true
        }
        if side != .top {
            separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
        if side != .trailing {
            separator.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        }
        if side != .leading {
            separator.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
        return separator
    }
}
