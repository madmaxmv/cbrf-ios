//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct RateCell: View {

    struct State: Equatable, Identifiable {
        var id: String { characterCode + value }
        let flag: String
        let characterCode: String
        let details: String
        let value: String
    }
    let state: State

    var body: some View {
        HStack {
            Text(state.flag)
                .font(.headline)
                .padding(.bottom)
            VStack(alignment: .leading) {
                Text(state.characterCode)
                    .font(.headline)
                    .foregroundColor(Color.blue)
                Text(state.details)
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
            }
            Spacer()
            Text(state.value)
        }
    }
}

struct RateCell_Previews: PreviewProvider {
    static var previews: some View {
        RateCell(
            state: RateCell.State(
                flag: "🇪🇺",
                characterCode: "EUR",
                details: "1 Euro",
                value: "90"
            )
        )
    }
}
