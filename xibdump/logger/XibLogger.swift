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
        self.context = ParserContext(xibFile: xibFile, onlyNibParsing: true)
        super.init()
    }

    final func printDump() {
        self.context.clean()
        if let firstObject = self.context.xibFile.xibObjects.first {
            parse(object: firstObject, parameterName: "", context: self.context)
        }
    }
    
    fileprivate func parse(object: XibObject, parameterName: String, context: ParserContext, tabCount: Int = 0) {
        
        let suffix: String = object.isSerialized ? " -->" : ""
        print("\(String(repeating: "\t", count: tabCount))|O|-\(object.xibClass.name)(\(object.objectId))\(suffix)")
        
        if object.isSerialized {
            return
        }
        object.isSerialized = true
        
        print("\(String(repeating: "\t", count: tabCount+1))|")
                
        for parameter in object.parameters(with: context) {
            
            print("\(String(repeating: "\t", count: tabCount+1))|P|-\(parameter.description())")
            self.parse(parentObject: object, parameter: parameter, context: context, tabCount: tabCount+1)
        }        
    }
    
    fileprivate func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext, tabCount: Int = 0) {
        
        if let xibObject = parameter.object(with: context) {
            self.parse(object: xibObject, parameterName: parameter.name, context: context, tabCount: tabCount)
        }
    }
}



extension XibFile {
    
    func logToConsole() {
        
        let logger = XibLogger(xibFile: self)
        logger.printDump()
        print("\n\n")
    }
}
