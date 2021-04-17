//
//  Copyright © 2021 Matyushenko Maxim. All rights reserved.
//

import Foundation

typealias Reducer<State, Event, Environment>
    = (inout State, Event) -> [Effect<Event, Environment>]
