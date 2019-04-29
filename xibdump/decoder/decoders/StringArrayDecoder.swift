//
//  StringArrayDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/10/19.
//

import Cocoa

class StringArrayDecoder: DefaultTagDecoder {

    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            StringArrayDecoder(parameterName: "UIScopeButtonTitles",
                            objectClassName: "NSArray",
                            tagName: "scopeButtonTitles",
                            needAddId: false,
                            tagMapper: nil,
                            keyParameter: nil)
        ]
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        if case let .tag(tag, _) = result {
            
            guard let object = parameter.object(with: context) else {
                return result
            }
            
            for obj in object.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "NSString", context: context) {
                
                if let value = obj.firstStringValue(with: context) {
                    let stringTag = Tag(name: "string")
                    stringTag.value = value
                    tag.add(tag: stringTag)
                }
            }
            
            return .tag(tag, false)
        }
        
        return result
    }
}
