//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import RxSwift

extension ObservableType {
    /// Assert that there is no errors before convert to the Driver.
    func assertError() -> Observable<Self.Element> {
        return self.do(onError: { assertionFailure("This should not have happened: \($0.localizedDescription)") })
    }
}
