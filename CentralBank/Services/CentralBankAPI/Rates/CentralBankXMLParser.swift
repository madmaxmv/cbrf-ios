//
//  CentralBankXMLParser.swift
//  CentralBank
//
//  Created by Максим on 22/01/2018.
//  Copyright © 2018 Matyushenko Maxim. All rights reserved.
//

import Foundation
import SWXMLHash

protocol CentralBankXMLDecoder {
    associatedtype Result
    init(data: Data)
    
    func decode() -> Result
}


final class XMLDecoder: CentralBankXMLDecoder {
    typealias Result = [RateAPIModel]

    let xml: XMLIndexer

    init(data: Data) {
        xml = SWXMLHash.parse(data)
    }
    
    func decode() -> Result {
        return xml["ValCurs"].children.map {
            RateAPIModel(xml: $0)
        }
    }
}

protocol XMLDecodable {
    init(xml: XMLIndexer)
}

struct RateAPIModel: XMLDecodable {
    let id: String
    let code: String
    let characterCode: String
    let nominal: Int
    let name: String
    let value: String
    
    init(xml: XMLIndexer) {
        id = xml.element!.attribute(by: "ID")!.text
        code = xml["NumCode"].element!.text
        characterCode = xml["CharCode"].element!.text
        nominal = Int(xml["Nominal"].element!.text)!
        name = xml["Name"].element!.text
        value = xml["Value"].element!.text
        
        print("case \(characterCode) = \(name)")
    }
}

