//
//  DateDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class DateDecoder: DefaultTagDecoder {

    static func allDecoders() -> [DefaultTagDecoder] {
        
        return [
            DateDecoder(parameterName: "UIDate"),
            DateDecoder(parameterName: "UIMinimumDate"),
            DateDecoder(parameterName: "UIMaximumDate")
        ]
    }
        
    init(parameterName: String) {
        super.init(parameterName: parameterName, objectClassName: "NSDate", tagName: "date", needAddId: false, tagMapper: nil)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        guard let value = object.findDoubleParameter(name: "NS.time", context: context) else {
            return .empty(true)
        }
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: parameter.name.systemParameterName())
        tag.addParameter(name: "timeIntervalSinceReferenceDate", value: "\(value)")
        
        
        return .tag(tag, false)
    }
    
    

}
