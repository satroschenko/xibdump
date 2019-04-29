//
//  VisualEffectSubviewDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa


class VisualEffectDecoder: NSObject {
    
    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            VisualEffectSubviewDecoder(),
            VisualEffectStyleDecoder()
        ]
    }
}


class VisualEffectSubviewDecoder: NewTagDecoder {

    
    init() {
        super.init(parameterName: "UIVisualEffectViewContentView",
                   objectClassName: "_UIVisualEffectContentView",
                   tagName: "view",
                   needAddId: true,
                   mapper: nil)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        
        if case let .tag(tag, _)  = result {
            
            tag.addParameter(name: "key", value: "contentView")
            tag.addParameter(name: "ambiguous", value: "YES")
        }
        
        return result
    }
}
