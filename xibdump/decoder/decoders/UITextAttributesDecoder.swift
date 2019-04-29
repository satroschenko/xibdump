//
//  UITextAttributesDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class UITextAttributesDecoder: DefaultTagDecoder {

    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            UITextAttributesDecoder(parameterName: "UITitleTextAttributes",
                                    objectClassName: "NSDictionary",
                                    tagName: "textAttributes",
                                    needAddId: false,
                                    tagMapper: nil,
                                    keyParameter: "titleTextAttributes"),
            
            UITextAttributesDecoder(parameterName: "UIBarLargeTitleTextAttributes",
                                    objectClassName: "NSDictionary",
                                    tagName: "textAttributes",
                                    needAddId: false,
                                    tagMapper: nil,
                                    keyParameter: "largeTitleTextAttributes")
        ]
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        
        if case let .tag(tag, _) = result {
            
            guard let object = parameter.object(with: context) else {
                return result
            }
            
            if let colorObject = object.findObjectParameter(name: "UINibEncoderEmptyKey", objectClass: "UIColor", context: context) {
                
                let colorTag = colorObject.extractColorTag(parentObject: parentObject, tagName: "color", parameterName: "textColor", context: context)
                tag.add(tag: colorTag)
            }
            
            if let shadowObject = object.findObjectParameter(name: "UINibEncoderEmptyKey", objectClass: "NSShadow", context: context) {
                
                let shadowTag = Tag(name: "offsetWrapper")
                shadowTag.addParameter(name: "key", value: "textShadowOffset")
                var needAddTag: Bool = false
                
                if let horizontal = shadowObject.findDoubleParameter(name: "NSShadowHoriz", context: context) {
                    shadowTag.addParameter(name: "horizontal", value: "\(horizontal)")
                    needAddTag = true
                }
                
                if let vertical = shadowObject.findDoubleParameter(name: "NSShadowVert", context: context) {
                    shadowTag.addParameter(name: "vertical", value: "\(vertical)")
                    needAddTag = true
                }
                
                if needAddTag {
                    tag.add(tag: shadowTag)
                }
                
                if let shColorObject = shadowObject.findObjectParameter(name: "NSShadowColor", objectClass: "UIColor", context: context) {
                    let colorTag = shColorObject.extractColorTag(parentObject: shadowObject,
                                                                 tagName: "color",
                                                                 parameterName: "textShadowColor",
                                                                 context: context)
                    tag.add(tag: colorTag)
                }
            }
        }
        
        return result
    }
}
