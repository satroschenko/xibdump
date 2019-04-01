//
//  UIAutoresizingMaskDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIAutoresizingMaskDecoder: NewTagDecoder {

    init() {
        super.init(parameterName: "UIAutoresizingMask", objectClassName: "", tagName: "autoresizingMask", needAddId: false)
    }
    
    override func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        

        let newTag = Tag(name: self.tagName)
        newTag.addParameter(name: "key", value: "autoresizingMask")
        
        
        newTag.add(tags: self.additianalChildTags())
        newTag.add(parameters: self.additianalChildParams())
        
        return .tag(newTag, true)
    }
}
