//
//  XibScanner.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa


class ParserContext: NSObject {
    
    let xibFile: XibFile
    init(xibFile: XibFile) {
        self.xibFile = xibFile
        super.init()
    }
}



extension XibParameterProtocol {
    
    func object(with context: ParserContext) -> XibObject? {
        
        if let obj = self as? XibObjectParameter {
            return context.xibFile.xibObjects[safe: obj.objectIndex]
        }
        return nil
    }
}


extension XibObject {
    
    func parameters(with context: ParserContext) -> [XibParameterProtocol] {
        
        var result = [XibParameterProtocol]()
        
        let start = xibValueIndex
        let end = xibValueIndex + valueCount
        
        for index in start ..< end {
            
            if let parameter = context.xibFile.xibParameters[safe:index] {
                
                result.append(parameter)
            }
        }
        
        return result
    }
}
