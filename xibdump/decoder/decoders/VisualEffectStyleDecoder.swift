//
//  VisualEffectStyleDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class VisualEffectStyleDecoder: TagDecoderProtocol {

    
    func handledClassNames() -> [String] {
        return [
            Utils.decoderKey(parameterName: "UIVisualEffectViewEffect", className: "UIVibrancyEffect", isTopLevel: true),
            Utils.decoderKey(parameterName: "UIVisualEffectViewEffect", className: "UIBlurEffect", isTopLevel: true)
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        if let vibrancyStyle = object.findIntParameter(name: "UIVibrancyEffectBlurStyle", context: context) {
            
            let tag = Tag(name: "vibrancyEffect")
            let blurTag = Tag(name: "blurEffect")
            blurTag.addParameter(name: "style", value: styleName(style: vibrancyStyle))
            tag.add(tag: blurTag)
            
            return .tag(tag, true)
        }
        
        if let blueStyle = object.findIntParameter(name: "UIBlurEffectStyle", context: context) {
            
            let blurTag = Tag(name: "blurEffect")
            blurTag.addParameter(name: "style", value: styleName(style: blueStyle))
            
            return .tag(blurTag, true)
        }
        
        return .empty(true)
    }
    
    fileprivate func styleName(style: Int) -> String {
        
        return ["extraLight", "light", "dark"][safe: style] ?? "extraLight"
    }
}
