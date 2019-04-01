//
//  OptionsParameterDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class AutoresizingMaskParameterDecoder: DefaultParameterDecoder {
    
    struct AutoresizedMasksOptionSet: OptionSet {
        let rawValue: Int
        
        static let flexibleMinX     = AutoresizedMasksOptionSet(rawValue: 1 << 0)
        static let widthSizable     = AutoresizedMasksOptionSet(rawValue: 1 << 1)
        static let flexibleMaxX     = AutoresizedMasksOptionSet(rawValue: 1 << 2)
        static let flexibleMinY     = AutoresizedMasksOptionSet(rawValue: 1 << 3)
        static let heightSizable    = AutoresizedMasksOptionSet(rawValue: 1 << 4)
        static let flexibleMaxY     = AutoresizedMasksOptionSet(rawValue: 1 << 5)
    }
    
    
    
    init() {
        super.init(parameterName: "UIAutoresizingMask", tagName: "autoresizingMask")
    }
    
    
    override func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let intParameter = parameter as? XibIntParameter else {
            return .empty(false)
        }
        
        let number = intParameter.value
        let optionSet = AutoresizedMasksOptionSet(rawValue: number)
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: parameter.name.xmlParameterName())
        
        if optionSet.contains(.flexibleMinX) {
            tag.addParameter(name: "flexibleMinX", value: "YES")
        }
        if optionSet.contains(.widthSizable) {
            tag.addParameter(name: "widthSizable", value: "YES")
        }
        if optionSet.contains(.flexibleMaxX) {
            tag.addParameter(name: "flexibleMaxX", value: "YES")
        }
        if optionSet.contains(.flexibleMinY) {
            tag.addParameter(name: "flexibleMinY", value: "YES")
        }
        if optionSet.contains(.heightSizable) {
            tag.addParameter(name: "heightSizable", value: "YES")
        }
        if optionSet.contains(.flexibleMaxY) {
            tag.addParameter(name: "flexibleMaxY", value: "YES")
        }
        
        return .tag(tag, false)
    }
}
