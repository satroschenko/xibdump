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
            BoolParameterDecoder(parameterName: "UIClearsContextBeforeDrawing", tagName: "clearsContextBeforeDrawing", inverse: false),
            BoolParameterDecoder(parameterName: "UIMultipleTouchEnabled", tagName: "multipleTouchEnabled", inverse: false),
            BoolParameterDecoder(parameterName: "UIAdjustsFontForContentSizeCategory", tagName: "adjustsFontForContentSizeCategory", inverse: false),
            BoolParameterDecoder(parameterName: "UIAdjustsLetterSpacingToFit", tagName: "adjustsLetterSpacingToFitWidth", inverse: false),
            BoolParameterDecoder(parameterName: "UIClipsToBounds", tagName: "clipsSubviews", inverse: false),
            BoolParameterDecoder(parameterName: "UIUserInteractionDisabled", tagName: "userInteractionEnabled", inverse: true),
        ]
    }
    
    
    init(parameterName: String, tagName: String, inverse: Bool = false) {
        self.inverse = inverse
        super.init(parameterName: parameterName, tagName: tagName)
    }
    
    override func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let boolParameter = parameter as? XibBoolParameter else {
            return .empty(false)
        }
        
        
        var value = boolParameter.value
        if self.inverse {
            value  = !value
        }
        
        let stringValue = value ? "YES":"NO"
        let tagParameter = TagParameter(name: tagName, value: stringValue)
        return .parameters([tagParameter], false)
    }
}
