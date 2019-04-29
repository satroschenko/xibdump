//
//  PointDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class PointDecoder: DefaultParameterDecoder {

    let firstName: String
    let secondName: String
    
    init(parameterName: String, firstName: String, secondName: String) {
        self.firstName = firstName
        self.secondName = secondName
        super.init(parameterName: parameterName, tagName: "")
    }
    
    override func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: parameterName, className: "NSString", isTopLevel: topLevelDecoder)]
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let value = parentObject.findStringParameter(name: parameterName, context: context) else {
            return .empty(false)
        }
        
        let point = NSPointFromString(value)
        
        let param1 = TagParameter(name: firstName, value: "\(point.x)")
        let param2 = TagParameter(name: secondName, value: "\(point.x)")
        
        return .parameters([param1, param2], false)
    }
}
