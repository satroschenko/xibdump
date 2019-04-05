//
//  BoolParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class BoolParameterDecoder: DefaultParameterDecoder {

    let inverse: Bool
    
    static func all() -> [DefaultParameterDecoder] {
        
        return [
            BoolParameterDecoder(parameterName: "UIClearsContextBeforeDrawing", tagName: "clearsContextBeforeDrawing"),
            BoolParameterDecoder(parameterName: "UIMultipleTouchEnabled", tagName: "multipleTouchEnabled"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontForContentSizeCategory", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAdjustsLetterSpacingToFit", tagName: "adjustsLetterSpacingToFitWidth"),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews"),
            BoolParameterDecoder(parameterName: "UIUserInteractionDisabled",
                                 tagName: "userInteractionEnabled",
                                 inverse: true,
                                 mapper: ["UISegment": "enabled"]),
            BoolParameterDecoder(parameterName: "UIHidden", tagName: "hidden"),
            BoolParameterDecoder(parameterName: "UIViewLayoutMarginsFollowReadableWidth", tagName: "layoutMarginsFollowReadableWidth"),
            BoolParameterDecoder(parameterName: "UIViewPreservesSuperviewMargins", tagName: "preservesSuperviewLayoutMargins"),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews"),
            BoolParameterDecoder(parameterName: "UIAutoresizeSubviews", tagName: "autoresizesSubviews"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontForContentSizeCategory", tagName: "adjustsFontForContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAdjustsImageSizeForAccessibilityContentSizeCategory",
                                 tagName: "adjustsImageSizeForAccessibilityContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UIAnimating", tagName: "animating"),
            BoolParameterDecoder(parameterName: "UIHidesWhenStopped", tagName: "hidesWhenStopped"),
            BoolParameterDecoder(parameterName: "UIHighlighted", tagName: "highlighted"),
            BoolParameterDecoder(parameterName: "UISelected", tagName: "selected"),
            BoolParameterDecoder(parameterName: "UIHidesWhenStopped", tagName: "hidesWhenStopped"),
            BoolParameterDecoder(parameterName: "UIDisabled", tagName: "enabled", inverse: true),
            BoolParameterDecoder(parameterName: "UISwitchOn", tagName: "on", inverse: true),
            BoolParameterDecoder(parameterName: "UIReversesTitleShadowWhenHighlighted", tagName: "reversesTitleShadowWhenHighlighted"),
            BoolParameterDecoder(parameterName: "UIShowsTouchWhenHighlighted", tagName: "showsTouchWhenHighlighted"),
            BoolParameterDecoder(parameterName: "UIAdjustsImageSizeForAccessibilityContentSizeCategory",
                                 tagName: "adjustsImageSizeForAccessibilityContentSizeCategory"),
            BoolParameterDecoder(parameterName: "UISpringLoaded", tagName: "springLoaded"),
            BoolParameterDecoder(parameterName: "UIMomentary", tagName: "momentary"),
            BoolParameterDecoder(parameterName: "UIClearsOnBeginEditing", tagName: "clearsOnBeginEditing"),
            BoolParameterDecoder(parameterName: "UIAdjustsFontSizeToFit", tagName: "adjustsFontForContentSizeCategory")
            
        ]
    }
    
    
    init(parameterName: String, tagName: String, inverse: Bool = false, mapper: [String: String]? = nil) {
        self.inverse = inverse
        super.init(parameterName: parameterName, tagName: tagName, mapper: mapper)
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let boolParameter = parameter as? XibBoolParameter else {
            return .empty(false)
        }
        
        
        var value = boolParameter.value
        if self.inverse {
            value  = !value
        }
        
        var finalTagName = tagName
        if let mapper = mapper {
            let parentClassName = parentObject.originalClassName(context: context)
            if let newTag = mapper[parentClassName] {
                finalTagName = newTag
            }
        }
        
        let stringValue = value ? "YES":"NO"
        let tagParameter = TagParameter(name: finalTagName, value: stringValue)
        return .parameters([tagParameter], false)
    }
}
