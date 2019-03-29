//
//  XibNullParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibNullParameter: NSObject, XibParameterProtocol {
    
    let name: String
    
    init(name: String) {
        self.name = name
        super.init()
    }
    
    func toString() -> String {
        return "(null)\(name)"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return nil
    }
}
