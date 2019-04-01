//
//  UIColorDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIColorDecoder: NewTagDecoder {

    init(parameterName: String) {
        super.init(parameterName: parameterName, objectClassName: "UIColor", tagName: "color", needAddId: false)
    }
    
    
    override func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        let newTag = Tag(name: self.tagName)
        newTag.addParameter(name: "key", value: parameterName.xmlParameterName())
        newTag.addParameter(name: "colorSpace", value: "custom")

        if let colorSpaceIndex = object.findIntParameter(name: "NSColorSpace", context: context) {
    
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
        
        newTag.add(tags: self.additianalChildTags())
        newTag.add(parameters: self.additianalChildParams())
        
        return .tag(newTag, true)
    }
}
