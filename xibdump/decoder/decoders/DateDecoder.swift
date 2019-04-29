//
//  DateDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class DateDecoder: NewTagDecoder {

    static func allDecoders() -> [NewTagDecoder] {
        
        return [
            DateDecoder(parameterName: "UIDate"),
            DateDecoder(parameterName: "UIMinimumDate"),
            DateDecoder(parameterName: "UIMaximumDate")
        ]
    }
    
    let key: String?
    
    init(parameterName: String, key: String? = nil, mapper: [String: String]? = nil) {
        self.key = key
        super.init(parameterName: parameterName, objectClassName: "NSDate", tagName: "date", needAddId: false, mapper: mapper)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        guard let value = object.findDoubleParameter(name: "NS.time", context: context) else {
            return .empty(true)
        }
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: parameter.name.xmlParameterName())
        tag.addParameter(name: "timeIntervalSinceReferenceDate", value: "\(value)")
        
        
        return .tag(tag, false)
    }
    
    

}
