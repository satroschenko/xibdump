//
//  XibLogger.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class XibLogger: NSObject {

    let context: ParserContext

    init(xibFile: XibFile) {
        self.context = ParserContext(xibFile: xibFile)
        super.init()
    }

    final func printDump() {
        self.context.xibFile.clean()
        if let firstObject = self.context.xibFile.xibObjects.first {
            parse(object: firstObject, parameterName: "", context: self.context)
        }
    }
    
    fileprivate func parse(object: XibObject, parameterName: String, context: ParserContext, tabCount: Int = 0) {
        
        print("\(String(repeating: "\t", count: tabCount))|O|-\(object.xibClass.name)(\(object.objectId))")
        
        if object.isSerialized {
            return
        }
        object.isSerialized = true
        
        print("\(String(repeating: "\t", count: tabCount+1))|")
        
        let start = object.xibValueIndex
        let end = object.xibValueIndex + object.valueCount
        
        for index in start ..< end {
            
            if let parameter = context.xibFile.xibParameters[safe:index] {
                
                print("\(String(repeating: "\t", count: tabCount+1))|P|-\(parameter.toString())")
                self.parse(parentObject: object, parameter: parameter, context: context, tabCount: tabCount+1)
            }
        }
        
        return
    }
    
    fileprivate func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext, tabCount: Int = 0) {
        
        if let xibObject = parameter.object(with: context) {
            self.parse(object: xibObject, parameterName: parameter.name, context: context, tabCount: tabCount)
        }
    }
}
