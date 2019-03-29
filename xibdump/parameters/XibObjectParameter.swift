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
    
    init(name: String, objectIndex: Int) {
        self.name = name
        self.objectIndex = objectIndex
        super.init()
    }
    
    func toString() -> String {
        return "(object)\(name):"
    }
    
    func object(with context: ParserContext) -> XibObject? {
        return context.xibFile.xibObjects[safe: objectIndex]
    }
}
