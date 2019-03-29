//
//  XibBoolParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibBoolParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let value: Bool
    
    init(name: String, value: Bool) {
        self.name = name
        self.value = value
        super.init()
    }
    
    func toString() -> String {
        return "(bool)\(name): \(value)"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return nil
    }
}
