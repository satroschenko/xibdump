//
//  XibNullParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibNullParameter: NSObject, XibParameterProtocol {
    
    let name: String
    let type: XibParameterType = .null
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func toString() -> String {
        return "(null)\(name)"
    }
}
