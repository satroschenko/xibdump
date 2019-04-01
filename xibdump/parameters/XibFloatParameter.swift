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
    let type: XibParameterType
    
    init(name: String, value: Float) {
        self.name = name
        self.value = value
        self.type = .float
        super.init()
    }
    
    func description() -> String {
        return "(float)\(name): \(value)"
    }
    
    func stringValue() -> String {
        return "\(value)"
    }
}
