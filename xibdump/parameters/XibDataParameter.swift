//
//  XibDataParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibDataParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let value: Data
    let type: XibParameterType = .data
    
    
    static func parameter(with name: String, value: Data) -> XibDataParameter {
        
        let className = "xibdump.Xib" + name + "Parameter"
        if let clazz = NSClassFromString(className) {
            if clazz is XibDataParameter.Type {
                if let inst = (clazz as? XibDataParameter.Type)?.init(name: name, value: value) {
                    return inst
                }
            }
        }
        
        return XibDataParameter(name: name, value: value)
        
    }
    
    required init(name: String, value: Data) {
        self.name = name
        self.value = value
        super.init()
    }
    
    func description() -> String {
        let string = String(data: value, encoding: .utf8) ?? ""
        return "(data)\(name): \(string)"
    }
    
    func stringValue() -> String {
        return String(data: self.value, encoding: .utf8) ?? ""
    }
}
