//
//  XibParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa


protocol XibParameterProtocol: class {
    var name: String {get}
    
    func toString() -> String
    
    func object(with context: ParserContext) -> XibObject?
}
