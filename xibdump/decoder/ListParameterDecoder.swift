//
//  ListParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class ListParameterDecoder: DefaultParameterDecoder {

    let values: [String]
    
    static let contentModes: [String] = [
        "scaleToFill",
        "scaleAspectFit",
        "scaleAspectFill",
        "redraw",
        "center",
        "top",
        "bottom",
        "left",
        "right",
        "topLeft",
        "topRight",
        "bottomLeft",
        "bottomRight"
    ]
    
    static let aligments: [String] = [
        "left",
        "center", //TODO: On Mac: right
        "right", //TODO: On Mac: center
        "justified",
        "natural"
    ]
    
    static let lineBreaks: [String] = [
        "wordWrap",
        "characterWrap",
        "clip",
        "headTruncation",
        "tailTruncation",
        "middleTruncation"
    ]
    
    static let semanticAttributes: [String] = [
        "unspecified",
        "playback",
        "spatial",
        "forceLeftToRight",
        "forceRightToLeft"
    ]
    
    static func all() -> [DefaultParameterDecoder] {
        
        return [
            ListParameterDecoder(parameterName: "UIContentMode", tagName: "contentMode", values: ListParameterDecoder.contentModes),
            ListParameterDecoder(parameterName: "UITextAlignment", tagName: "textAlignment", values: ListParameterDecoder.aligments),
            ListParameterDecoder(parameterName: "UILineBreakMode", tagName: "lineBreakMode", values: ListParameterDecoder.lineBreaks),
            
            ListParameterDecoder(parameterName: "UIViewSemanticContentAttribute",
                                 tagName: "semanticContentAttribute",
                                 values: ListParameterDecoder.semanticAttributes),
            
            ListParameterDecoder(parameterName: "UIProgressViewStyle",
                                 tagName: "progressViewStyle",
                                 values: ["default", "bar"]),
            
            ListParameterDecoder(parameterName: "UIActivityIndicatorViewStyle",
                                 tagName: "style",
                                 values: ["whiteLarge", "white", "gray"]),
            
            ListParameterDecoder(parameterName: "UIContentVerticalAlignment",
                                 tagName: "contentVerticalAlignment",
                                 values: ["center", "top", "bottom", "fill"]),
            
            ListParameterDecoder(parameterName: "UIContentHorizontalAlignment",
                                 tagName: "contentHorizontalAlignment",
                                 values: ["center", "left", "right", "fill", "leading", "trailing"]),
            
            ListParameterDecoder(parameterName: "UIButtonType",
                                 tagName: "buttonType",
                                 values: ["custom", "roundedRect", "detailDisclosure", "infoLight", "infoDark", "contactAdd"]),
            
            ListParameterDecoder(parameterName: "UIBorderStyle",
                                 tagName: "borderStyle",
                                 values: ["none", "line", "bezel", "roundedRect"]),
            
            ListParameterDecoder(parameterName: "UIClearButtonMode",
                                 tagName: "clearButtonMode",
                                 values: ["0", "whileEditing", "unlessEditing", "always"]),
            
            ListParameterDecoder(parameterName: "UIStackViewAlignment",
                                 tagName: "alignment",
                                 values: ["fill", "top", "firstBaseline", "center", "bottom", "lastBaseline"]),
            
            ListParameterDecoder(parameterName: "UIStackViewDistribution",
                                 tagName: "distribution",
                                 values: ["fill", "fillEqually", "fillProportionally", "equalSpacing", "equalCentering"]),
            
            ListParameterDecoder(parameterName: "UIStackViewAxis",
                                 tagName: "axis",
                                 values: ["horizontal", "vertical"]),
            
            ListParameterDecoder(parameterName: "UIIndicatorStyle",
                                 tagName: "indicatorStyle",
                                 values: ["default", "black", "white"]),
            
            ListParameterDecoder(parameterName: "UIKeyboardDismissMode",
                                 tagName: "keyboardDismissMode",
                                 values: ["default", "onDrag", "interactive"]),
            
            ListParameterDecoder(parameterName: "UIDatePickerMode",
                                 tagName: "datePickerMode",
                                 values: ["time", "date", "dateAndTime", "countDownTimer"]),
            
            ListParameterDecoder(parameterName: "MKMapType",
                                 tagName: "mapType",
                                 values: ["standard", "satellite", "hybrid", "satelliteFlyover", "hybridFlyover", "mutedStandard"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableColorFormatCoderKey",
                                 tagName: "drawableColorFormat",
                                 values: ["RGBA8888", "RGB565", "SRGBA8888"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableDepthFormatCoderKey",
                                 tagName: "drawableDepthFormat",
                                 values: ["none", "16", "24"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableStencilFormatCoderKey",
                                 tagName: "drawableStencilFormat",
                                 values: ["none", "8"]),
            
            ListParameterDecoder(parameterName: "GLKViewDrawableMultisampleCoderKey",
                                 tagName: "drawableMultisample",
                                 values: ["none", "4X"])
        ]
    }
    
    
    init(parameterName: String, tagName: String, values: [String]) {
        self.values = values
        super.init(parameterName: parameterName, tagName: tagName)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        let number = intParameter.value
        
        let value = self.values[safe: number] ?? values.first!
        let tagParameter = TagParameter(name: tagName, value: value)
        return .parameters([tagParameter], false)
    }
}
