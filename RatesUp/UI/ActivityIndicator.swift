//
//  RatesUp
//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {

    let style: UIActivityIndicatorView.Style

    init(style: UIActivityIndicatorView.Style = .medium) {
        self.style = style
    }

    func makeUIView(context: Context) -> some UIView {
        let view = UIActivityIndicatorView(style: style)
        view.startAnimating()
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
