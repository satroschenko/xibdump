//
//  UIColorDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIColorDecoder: NewTagDecoder {
    
    
    static func allDecoders() -> [NewTagDecoder] {
        
        return [
            UIColorDecoder(parameterName: "UIBackgroundColor"),
            UIColorDecoder(parameterName: "UITintColor"),
            UIColorDecoder(parameterName: "UITextColor"),
            UIColorDecoder(parameterName: "UIHighlightedColor"),
            UIColorDecoder(parameterName: "UIShadowColor"),
            UIColorDecoder(parameterName: "UIProgressTrackTintColor", key: "trackTintColor"),
            UIColorDecoder(parameterName: "UIProgressProgressTintColor", key: "progressTintColor"),
            UIColorDecoder(parameterName: "UISwitchOnTintColor", key: "onTintColor"),
            UIColorDecoder(parameterName: "UISwitchThumbTintColor", key: "thumbTintColor"),
            UIColorDecoder(parameterName: "UIMinimumTintColor", key: "minimumTrackTintColor"),
            UIColorDecoder(parameterName: "UIMaximumTintColor", key: "maximumTrackTintColor"),
            UIColorDecoder(parameterName: "UIThumbTintColor")
        ]
    }
    
    let key: String?

    init(parameterName: String, key: String? = nil) {
        self.key = key
        super.init(parameterName: parameterName, objectClassName: "UIColor", tagName: "color", needAddId: false)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        let newTag = UIColorDecoder.extractColorTag(object: object,
                                                    tagName: tagName,
                                                    parameterName: parameterName,
                                                    context: context,
                                                    key: key)
        return .tag(newTag, false)
    }
    

    static func extractColorTag(object: XibObject, tagName: String, parameterName: String, context: ParserContext, key: String? = nil) -> Tag {
        
        let newTag = Tag(name: tagName)
        newTag.addParameter(name: "key", value: key ?? parameterName.xmlParameterName() )
        newTag.addParameter(name: "colorSpace", value: "custom")
        
        if let systemColorName = object.findStringParameter(name: "UISystemColorName", context: context) {
            newTag.addParameter(name: "cocoaTouchSystemColor", value: systemColorName)
            
        } else if let colorSpaceIndex = object.findIntParameter(name: "NSColorSpace", context: context) {
            
            if colorSpaceIndex == 2 { // Generic sRGB.
                if let redValue = object.findFloatParameter(name: "UIRed", context: context) {
                    newTag.addParameter(name: "red", value: "\(redValue)")
                }
                
                if let greenValue = object.findFloatParameter(name: "UIGreen", context: context) {
                    newTag.addParameter(name: "green", value: "\(greenValue)")
                }
                
                if let blueValue = object.findFloatParameter(name: "UIBlue", context: context) {
                    newTag.addParameter(name: "blue", value: "\(blueValue)")
                }
                
                if let alphaValue = object.findFloatParameter(name: "UIAlpha", context: context) {
                    newTag.addParameter(name: "alpha", value: "\(alphaValue)")
                }
                
                newTag.addParameter(name: "customColorSpace", value: "sRGB")
                
            } else if colorSpaceIndex == 4 { // genericGamma22GrayColorSpace
                
                if let alphaValue = object.findFloatParameter(name: "UIAlpha", context: context) {
                    newTag.addParameter(name: "alpha", value: "\(alphaValue)")
                }
                
                if let whiteValue = object.findFloatParameter(name: "NSWhite", context: context) {
                    newTag.addParameter(name: "white", value: "\(whiteValue)")
                }
                
                newTag.addParameter(name: "customColorSpace", value: "genericGamma22GrayColorSpace")
                
            } else {
                print("Unknown ColorSpaceType: \(colorSpaceIndex)")
            }
        }
        
        newTag.innerObjectId = object.objectId
        
        return newTag
    }
}