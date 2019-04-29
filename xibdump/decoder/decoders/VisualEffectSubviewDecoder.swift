//
//  VisualEffectSubviewDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa


class VisualEffectDecoder: NSObject {
    
    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            VisualEffectSubviewDecoder(),
            VisualEffectStyleDecoder()
        ]
    }
}


class VisualEffectSubviewDecoder: DefaultTagDecoder {

    
    init() {
        super.init(parameterName: "UIVisualEffectViewContentView",
                   objectClassName: "_UIVisualEffectContentView",
                   tagName: "view",
                   needAddId: true)
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
