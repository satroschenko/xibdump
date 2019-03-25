//
//  XibObject.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class XibObject: NSObject {

    let xibClass: XibClass
    let xibValueIndex: Int
    let valueCount: Int
    let objectId: String
    
    var isSerialized: Bool = false
    
    init(xibClass: XibClass, xibValueIndex: Int, valueCount: Int) {
        self.xibClass = xibClass
        self.xibValueIndex = xibValueIndex
        self.valueCount = valueCount
        self.objectId = XibID.generate()
        super.init()
    }
    
    
    override var description: String {
        return "XibObject/ [Class: \(self.xibClass). XibValueIndex: \(self.xibValueIndex). ValueCount: \(valueCount).]"
    }
    
}
