//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

import SwiftUI

struct RateCell: View {

    struct State: Equatable, Identifiable {
        let id: String
        let flag: String
        let characterCode: String
        let details: String
        let value: String
    }
    let state: State

    var body: some View {
        Group {
            HStack {
                Text(state.flag)
                    .font(.title)
                    .padding(.bottom)
                VStack(alignment: .leading, spacing: 4) {
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
            .padding(12)
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding([.leading, .trailing], 12)
    }
}

struct RateCell_Previews: PreviewProvider {

    static var previews: some View {
        RateCell(
            state: RateCell.State(
                id: "Some ID",
                flag: "🇪🇺",
                characterCode: "EUR",
                details: "1 Euro",
                value: "90"
            )
        )
    }
}
