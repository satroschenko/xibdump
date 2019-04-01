//
//  XibObjectParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibObjectParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let objectIndex: Int
    let type: XibParameterType = .object
    
    init(name: String, objectIndex: Int) {
        self.name = name
        self.objectIndex = objectIndex
        super.init()
    }
    
    func description() -> String {
        return "(object)\(name):"
    }
    
    func stringValue() -> String {
        return ""
    }
}
