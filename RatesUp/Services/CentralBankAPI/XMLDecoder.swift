//
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import SWXMLHash

protocol XMLDecodable {
    init(xml: XMLIndexer)
}

final class XMLDecoder {
    let xml: XMLIndexer

    init(data: Data) {
        xml = SWXMLHash.parse(data)
    }
    
    func decode<Result: XMLDecodable>() -> Result {
        return Result.init(xml: xml)
    }
}




