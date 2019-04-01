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
    let type: XibParameterType
    
    init(name: String, value: Int, type: XibParameterType) {
        self.name = name
        self.value = value
        self.type = type
        super.init()
    }
    
    func description() -> String {
        return "(int)\(name): \(value)"
    }
    
    func stringValue() -> String {
        return "\(value)"
    }
}
