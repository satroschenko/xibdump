//
//  UIColorDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIColorDecoder: DefaultTagDecoder {
    
    
    static func allDecoders() -> [DefaultTagDecoder] {
        
        return [
            UIColorDecoder(parameterName: "UIBackgroundColor"),
            UIColorDecoder(parameterName: "UITintColor", key: "tintColor", keyMapper: ["UITabBar": "selectedImageTintColor"]),
            UIColorDecoder(parameterName: "UITextColor"),
            UIColorDecoder(parameterName: "UIHighlightedColor"),
            UIColorDecoder(parameterName: "UIShadowColor", key: "shadowColor", keyMapper: ["UIButtonContent": "titleShadowColor"]),
            UIColorDecoder(parameterName: "UIProgressTrackTintColor", key: "trackTintColor"),
            UIColorDecoder(parameterName: "UIProgressProgressTintColor", key: "progressTintColor"),
            UIColorDecoder(parameterName: "UISwitchOnTintColor", key: "onTintColor"),
            UIColorDecoder(parameterName: "UISwitchThumbTintColor", key: "thumbTintColor"),
            UIColorDecoder(parameterName: "UIMinimumTintColor", key: "minimumTrackTintColor"),
            UIColorDecoder(parameterName: "UIMaximumTintColor", key: "maximumTrackTintColor"),
            UIColorDecoder(parameterName: "UIThumbTintColor"),
            UIColorDecoder(parameterName: "UITitleColor"),
            UIColorDecoder(parameterName: "UICurrentPageIndicatorTintColor"),
            UIColorDecoder(parameterName: "UIPageIndicatorTintColor"),
            UIColorDecoder(parameterName: "UIBarTintColor"),
            UIColorDecoder(parameterName: "UIBadgeColor"),
            UIColorDecoder(parameterName: "UISeparatorColor"),            
            UIColorDecoder(parameterName: "UISectionIndexBackgroundColor"),
            UIColorDecoder(parameterName: "UISectionIndexTrackingBackgroundColor"),
            UIColorDecoder(parameterName: "UISectionIndexColor")
        ]
    }
    
    init(parameterName: String, key: String? = nil, keyMapper: [String: String]? = nil) {
        super.init(parameterName: parameterName,
                   objectClassName: "UIColor",
                   tagName: "color",
                   needAddId: false,
                   tagMapper: nil,
                   keyParameter: key,
                   keyMapper: keyMapper)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        let newTag = object.extractColorTag(parentObject: parentObject,
                                            tagName: tagName,
                                            parameterName: parameterName,
                                            context: context,
                                            key: keyParameter,
                                            keyMapper: keyMapper)
        return .tag(newTag, false)
    }
}
