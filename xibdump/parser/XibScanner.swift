//
//  XibScanner.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa


class ParserContext: NSObject {
    
    let xibFile: XibFile
    var runtimeAttributes: [String: Tag] = [String: Tag]()
    var imageResources: [Tag] = [Tag]()
    
    init(xibFile: XibFile) {
        self.xibFile = xibFile
        super.init()
    }
    
    func clean() {
        xibFile.clean()
        runtimeAttributes.removeAll()
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
    
    
    func firstStringValue(with context: ParserContext) -> String? {
        
        if let parameter = context.xibFile.xibParameters[safe: self.xibValueIndex] {
            return parameter.stringValue()
        }
        
        return nil
    }
    
    func parameter(with name: String, context: ParserContext) -> XibParameterProtocol? {
        
        for parameter in parameters(with: context) where parameter.name == name {
            return parameter
        }
        
        return nil
    }
    
    func findIntParameter(name: String, context: ParserContext) -> Int? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let intParameter = parameter as? XibIntParameter {
                return intParameter.value
            }
        }
        return nil
    }
    
    func findBoolParameter(name: String, context: ParserContext) -> Bool? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let boolParameter = parameter as? XibBoolParameter {
                return boolParameter.value
            }
        }
        return nil
    }
    
    func findFloatParameter(name: String, context: ParserContext) -> Float? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let floatParameter = parameter as? XibFloatParameter {
                return floatParameter.value
            }
        }
        return nil
    }
    
    func findDoubleParameter(name: String, context: ParserContext) -> Double? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let doubleParameter = parameter as? XibDoubleParameter {
                return doubleParameter.value
            }
        }
        return nil
    }
    
    func findStringParameter(name: String, context: ParserContext) -> String? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let stringObject = parameter.object(with: context) {
                return stringObject.firstStringValue(with: context)
            }
        }
        return nil
    }
    
    func findDataParameter(name: String, context: ParserContext) -> Data? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let dataParameter = parameter as? XibDataParameter {
                return dataParameter.value
            }
        }
        return nil
    }
    
    func findObjectParameter(name: String, context: ParserContext) -> XibObject? {
        
        for parameter in parameters(with: context) {
            
            if parameter.name != name {
                continue
            }
            
            if let objectParameter = parameter as? XibObjectParameter {
                return objectParameter.object(with: context)
            }
        }
        return nil
    }
}
