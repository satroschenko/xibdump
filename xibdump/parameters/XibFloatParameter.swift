//
//  XibFloatParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibFloatParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let value: Float
    
    init(name: String, value: Float) {
        self.name = name
        self.value = value
        super.init()
    }
    
    func toString() -> String {
        return "(float)\(name): \(value)"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return nil
    }
}
