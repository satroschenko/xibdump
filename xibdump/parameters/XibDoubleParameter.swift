//
//  XibDoubleParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibDoubleParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let value: Double
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
        super.init()
    }
    
    func toString() -> String {
        return "(double)\(name): \(value)"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return nil
    }
}
