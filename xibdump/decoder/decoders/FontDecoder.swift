//
//  FontDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class FontDecoder: NSObject, TagDecoderProtocol {

    func handledClassNames() -> [String] {
        return [
            Utils.decoderKey(parameterName: "UIFont", className: "UIFont", isTopLevel: true),
            Utils.decoderKey(parameterName: "T.UINibEncoderEmptyKey", className: "UIFont", isTopLevel: true)
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = object.extractFontTag(tagName: "fontDescription", key: "fontDescription", context: context)
        
        return .tag(tag, false)
    }
    
    
    
}
