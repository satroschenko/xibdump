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
    let type: XibParameterType
    
    init(name: String, value: Bool) {
        self.name = name
        self.value = value
        if value {
            self.type = .aTrue
        } else {
            self.type = .aFalse
        }
        super.init()
    }
    
    func description() -> String {
        return "(bool)\(name): \(value)"
    }
    
    func stringValue() -> String {
        return value ? "YES" : "NO"
    }
}
