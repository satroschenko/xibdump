//
//  SKViewDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class SKViewDecoder: DefaultTagDecoder {
    
    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            SKViewDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "SKView", tagName: "skView"),
            SKViewDecoder(parameterName: "UINibEncoderEmptyKey", objectClassName: "ARSKView", tagName: "arskView")
        ]
    }

    init(parameterName: String, objectClassName: String, tagName: String) {
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName)
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        if case let .tag(tag, _)  = result {
            
            guard let object = parameter.object(with: context) else {
                return result
            }
            
            guard let infoObj = object.findObjectParameter(name: "_info", context: context) else {
                return result
            }
            
            var keyFound: Bool = false
            for param in infoObj.parameters(with: context) where param.name == "UINibEncoderEmptyKey" {
                
                if let pObject = param.object(with: context) {
                    
                    if keyFound {
                        if let name = pObject.firstStringValue(with: context) {
                            
                            tag.addParameter(name: "sceneName", value: name)
                            break
                        }
                    }
                    
                    
                    if pObject.firstStringValue(with: context) == "_ib_SceneName" {
                        keyFound = true
                    }
                }
            }
        }
        
        return result
    }
}
