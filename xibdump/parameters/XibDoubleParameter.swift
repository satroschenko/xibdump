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
    let type: XibParameterType
    
    init(name: String, value: Double) {
        self.name = name
        self.value = value
        self.type = .double
        super.init()
    }
    
    func description() -> String {
        return "(double)\(name): \(value)"
    }
    
    func stringValue() -> String {
        return "\(value)"
    }
}
