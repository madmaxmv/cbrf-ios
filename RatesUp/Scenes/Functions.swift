//
//  Copyright © 2020 Matyushenko Maxim. All rights reserved.
//

func update<V>(_ value: V, _ block: (V) -> Void) -> V {
    block(value)
    return value
}
