//
//  ColorUtils.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa

extension XibObject {
    
    func extractColorTag(parentObject: XibObject,
                         tagName: String,
                         parameterName: String,
                         context: ParserContext,
                         key: String? = nil,
                         keyMapper: [String: String]? = nil) -> Tag {
        
        let newTag = Tag(name: tagName)
        newTag.addParameter(name: "colorSpace", value: "custom")
        
        var finalKey = key ?? parameterName.systemParameterName()
        if let keyMapper = keyMapper {
            
            let parentClassName = parentObject.originalClassName(context: context)
            if let newKey = keyMapper[parentClassName] {
                finalKey = newKey
            }
        }
        
        newTag.addParameter(name: "key", value: finalKey )
        
        if let systemColorName = findStringParameter(name: "UISystemColorName", context: context), systemColorName != "tableBackgroundColor" {
            // tableBackgroundColor - default string for UITableView, but it crashes xCode.
            newTag.addParameter(name: "cocoaTouchSystemColor", value: systemColorName)
            
        } else
            if let colorSpaceIndex = findIntParameter(name: "NSColorSpace", context: context) {
                
                if colorSpaceIndex == 2 { // Generic sRGB.
                    if let redValue = findFloatParameter(name: "UIRed", context: context) {
                        newTag.addParameter(name: "red", value: "\(redValue)")
                    }
                    
                    if let greenValue = findFloatParameter(name: "UIGreen", context: context) {
                        newTag.addParameter(name: "green", value: "\(greenValue)")
                    }
                    
                    if let blueValue = findFloatParameter(name: "UIBlue", context: context) {
                        newTag.addParameter(name: "blue", value: "\(blueValue)")
                    }
                    
                    if let alphaValue = findFloatParameter(name: "UIAlpha", context: context) {
                        newTag.addParameter(name: "alpha", value: "\(alphaValue)")
                    }
                    
                    newTag.addParameter(name: "customColorSpace", value: "sRGB")
                    
                } else if colorSpaceIndex == 4 { // genericGamma22GrayColorSpace
                    
                    if let alphaValue = findFloatParameter(name: "UIAlpha", context: context) {
                        newTag.addParameter(name: "alpha", value: "\(alphaValue)")
                    }
                    
                    if let whiteValue = findFloatParameter(name: "NSWhite", context: context) {
                        newTag.addParameter(name: "white", value: "\(whiteValue)")
                    }
                    
                    newTag.addParameter(name: "customColorSpace", value: "genericGamma22GrayColorSpace")
                    
                } else {
                    print("Unknown ColorSpaceType: \(colorSpaceIndex)")
                }
        }
        
        newTag.innerObjectId = objectId
        
        return newTag
    }
    
    
}
