//
//  FirstStringDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/2/19.
//

import Cocoa

class FirstStringDecoder: DefaultParameterDecoder {

    static func all() -> [DefaultParameterDecoder] {
        
        return [
            FirstStringDecoder(parameterName: "UIText", tagName: "text"),
            FirstStringDecoder(parameterName: "UIResourceName", tagName: "image"),
            FirstStringDecoder(parameterName: "UIRestorationIdentifier", tagName: "restorationIdentifier"),
            FirstStringDecoder(parameterName: "UIClassName", tagName: "customClass")
        ]
    }
    
    override func handledClassNames() -> [String] {
        return ["T.\(parameterName)-NSString"]
    }
    
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {

        if let object = parameter.object(with: context), let value = object.firstStringValue(with: context) {
            return .parameters([TagParameter(name: tagName, value: value)], false)
        }
        
        return .empty(false)
    }
}
