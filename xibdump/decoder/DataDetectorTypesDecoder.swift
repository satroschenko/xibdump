//
//  DataDetectorTypesDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class DataDetectorTypesDecoder: NSObject, CustomTagDecoderProtocol {
    
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
        return ["T.UIDataDetectorTypes-"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        let tag = Tag(name: "dataDetectorType")
        tag.addParameter(name: "key", value: "dataDetectorTypes")
        
        DataDetectorTypesDecoder.decode(value: intParameter.value, context: context, tag: tag)
        
        return .tag(tag, false)
    }
    
    
    static func decode(value: Int, context: ParserContext, tag: Tag) {
        
        let optionSet = DataDetectorTypeOptionSet(rawValue: value)
        
        if optionSet.contains(.phoneNumber) {
            tag.addParameter(name: "phoneNumber", value: "YES")
        }
        if optionSet.contains(.link) {
            tag.addParameter(name: "link", value: "YES")
        }
        if optionSet.contains(.address) {
            tag.addParameter(name: "address", value: "YES")
        }
        if optionSet.contains(.calendarEvent) {
            tag.addParameter(name: "calendarEvent", value: "YES")
        }
        if optionSet.contains(.shipmentTrackingNumber) {
            tag.addParameter(name: "shipmentTrackingNumber", value: "YES")
        }
        if optionSet.contains(.flightNumber) {
            tag.addParameter(name: "flightNumber", value: "YES")
        }
        if optionSet.contains(.lookupSuggestion) {
            tag.addParameter(name: "lookupSuggestion", value: "YES")
        }
    }
}
