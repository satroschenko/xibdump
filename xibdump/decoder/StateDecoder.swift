//
//  StateDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/5/19.
//

import Cocoa

class StateDecoder: NSObject, CustomTagDecoderProtocol {
    
    static let states: [String] = [
        "normal",
        "highlighted",
        "disabled",
        "",
        "selected"
    ]

    func handledClassNames() -> [String] {
        return [
            "T.UIButtonStatefulContent-NSMutableDictionary",
            "T.UIButtonStatefulContent-NSDictionary",
            "T.UINibEncoderEmptyKey-UIButtonContent"
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        if parameter.name == "UIButtonStatefulContent" {
            return .empty(true)
        }
        
        guard let prevParameter = parentObject.previousParameter(parameter: parameter, context: context) else {
            return .empty(false)
        }
        
        guard let prevObj = prevParameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let index = prevObj.findIntParameter(name: "NS.intval", context: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "state")
        let state = StateDecoder.states[safe: index] ?? "normal"
        tag.addParameter(name: "key", value: state)
        
        
        return .tag(tag, true)
    }
}
