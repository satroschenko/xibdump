//
//  DataDetectorTypesDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class DataDetectorTypesDecoder: NSObject, TagDecoderProtocol {
    
    struct DataDetectorTypeOptionSet: OptionSet {
        
        let rawValue: Int
        
        static let phoneNumber              = DataDetectorTypeOptionSet(rawValue: 1 << 0)
        static let link                     = DataDetectorTypeOptionSet(rawValue: 1 << 1)
        static let address                  = DataDetectorTypeOptionSet(rawValue: 1 << 2)
        static let calendarEvent            = DataDetectorTypeOptionSet(rawValue: 1 << 3)
        static let shipmentTrackingNumber   = DataDetectorTypeOptionSet(rawValue: 1 << 4)
        static let flightNumber             = DataDetectorTypeOptionSet(rawValue: 1 << 5)
        static let lookupSuggestion         = DataDetectorTypeOptionSet(rawValue: 1 << 6)
    }

    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: "UIDataDetectorTypes", className: "", isTopLevel: true)]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        let tag = Tag(name: "dataDetectorType")
        tag.addParameter(name: "key", value: "dataDetectorTypes")
        tag.extractDataDetectorType(value: intParameter.value)
        
        return .tag(tag, false)
    }
}
