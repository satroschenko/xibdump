//
//  NSLocaleDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class NSLocaleDecoder: NSObject, CustomTagDecoderProtocol {

    
    func handledClassNames() -> [String] {
        return ["T.UILocale-NSLocale"]
    }
    
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let value = object.findStringParameter(name: "NS.identifier", context: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "locale")
        tag.addParameter(name: "key", value: "locale")
        tag.addParameter(name: "localeIdentifier", value: value)
        
        return .tag(tag, false)
    }
}
