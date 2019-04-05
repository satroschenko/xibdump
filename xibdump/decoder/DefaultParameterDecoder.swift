//
//  DefaultPropertyDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class DefaultParameterDecoder: NSObject, CustomTagDecoderProtocol {

    let parameterName: String
    let tagName: String
    let mapper: [String: String]?
    
    static func allDecoders() -> [DefaultParameterDecoder] {
        
        var result = [DefaultParameterDecoder]()
        
        result.append(contentsOf: [
            DefaultParameterDecoder(parameterName: "UIOpaque", tagName: "opaque"),
            DefaultParameterDecoder(parameterName: "UIPreferredMaxLayoutWidth", tagName: "preferredMaxLayoutWidth"),
            DefaultParameterDecoder(parameterName: "UIMinimumScaleFactor", tagName: "minimumScaleFactor"),
            DefaultParameterDecoder(parameterName: "UINumberOfLines", tagName: "numberOfLines"),
            DefaultParameterDecoder(parameterName: "UITag", tagName: "tag"),
            DefaultParameterDecoder(parameterName: "UIAlpha", tagName: "alpha"),
            DefaultParameterDecoder(parameterName: "UIMinimumFontSize", tagName: "minimumFontSize"),
            DefaultParameterDecoder(parameterName: "UIProgress", tagName: "progress"),
            DefaultParameterDecoder(parameterName: "UIValue", tagName: "value"),
            DefaultParameterDecoder(parameterName: "UIMinValue", tagName: "minValue"),
            DefaultParameterDecoder(parameterName: "UIMaxValue", tagName: "maxValue"),
            DefaultParameterDecoder(parameterName: "UISelectedSegmentIndex", tagName: "selectedSegmentIndex"),
            DefaultParameterDecoder(parameterName: "UINumberOfPages", tagName: "numberOfPages"),
            DefaultParameterDecoder(parameterName: "UICurrentPage", tagName: "currentPage"),
            DefaultParameterDecoder(parameterName: "UIMinimumValue", tagName: "minimumValue"),
            DefaultParameterDecoder(parameterName: "UIMaximumValue", tagName: "maximumValue"),
            DefaultParameterDecoder(parameterName: "UIStepValue", tagName: "stepValue")
            
            ])
        
        result.append(contentsOf: ListParameterDecoder.all())
        result.append(contentsOf: BoolParameterDecoder.all())
        result.append(contentsOf: FirstStringDecoder.all())
//        result.append(contentsOf: PointPropertySerializerParser.all())
        
        
        return result
    }
    
    
    init(parameterName: String, tagName: String, mapper: [String: String]? = nil) {
        self.parameterName = parameterName
        self.tagName = tagName
        self.mapper = mapper
        super.init()
    }
    
    func handledClassNames() -> [String] {
        return ["T.\(parameterName)-"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        if parameter.name == parameterName {
            let parameterValue = parameter.stringValue()
            
            var finalTagName = tagName
            if let mapper = mapper {
                let parentClassName = parentObject.originalClassName(context: context)
                if let newTag = mapper[parentClassName] {
                    finalTagName = newTag
                }
            }
            
            let tagParameter = TagParameter(name: finalTagName, value: parameterValue)
            return .parameters([tagParameter], false)
        }
        
        return .empty(false)
    }
}
