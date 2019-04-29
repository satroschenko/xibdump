//
//  ScreenEdgePanGestureRecognizerDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/12/19.
//

import Cocoa

class ScreenEdgePanGestureRecognizerDecoder: CustomTagDecoderProtocol {

    struct ScreenEdgeOptionSet: OptionSet {
        
        let rawValue: Int
        
        static let top              = ScreenEdgeOptionSet(rawValue: 1 << 0)
        static let left             = ScreenEdgeOptionSet(rawValue: 1 << 1)
        static let bottom           = ScreenEdgeOptionSet(rawValue: 1 << 2)
        static let right            = ScreenEdgeOptionSet(rawValue: 1 << 3)
    }
    
    func handledClassNames() -> [String] {
        return ["T.UIScreenEdgePanGestureRecognizer.edges-"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        if intParameter.value == 0 {
            return .empty(false)
        }
        
        let tag = Tag(name: "rectEdge")
        tag.addParameter(name: "key", value: "edges")
        
        let optionSet = ScreenEdgeOptionSet(rawValue: intParameter.value)
        
        if optionSet.contains(.left) {
            tag.addParameter(name: "left", value: "YES")
        }
        if optionSet.contains(.right) {
            tag.addParameter(name: "right", value: "YES")
        }
        if optionSet.contains(.top) {
            tag.addParameter(name: "top", value: "YES")
        }
        if optionSet.contains(.bottom) {
            tag.addParameter(name: "bottom", value: "YES")
        }
     
        return .tag(tag, false)
    }
}
