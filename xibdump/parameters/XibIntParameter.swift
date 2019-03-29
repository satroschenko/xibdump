//
//  XibIntParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/28/19.
//

import Cocoa

class XibIntParameter: NSObject, XibParameterProtocol {

    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
        super.init()
    }
    
    func toString() -> String {
        return "(int)\(name): \(value)"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return nil
    }
}
