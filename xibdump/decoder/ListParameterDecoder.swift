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
                                 values: ListParameterDecoder.semanticAttributes)
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
