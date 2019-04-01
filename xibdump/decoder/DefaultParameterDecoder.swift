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
    
    
    static func allDecoders() -> [DefaultParameterDecoder] {
        
        var result = [DefaultParameterDecoder]()
        
        result.append(contentsOf: [
            DefaultParameterDecoder(parameterName: "UIUserInteractionDisabled", tagName: "userInteractionEnabled"),
            DefaultParameterDecoder(parameterName: "UIOpaque", tagName: "opaque"),
            DefaultParameterDecoder(parameterName: "UIViewDoesNotTranslateAutoresizingMaskIntoConstraints",
                                    tagName: "translatesAutoresizingMaskIntoConstraints"),
            DefaultParameterDecoder(parameterName: "UIPreferredMaxLayoutWidth", tagName: "preferredMaxLayoutWidth"),
            DefaultParameterDecoder(parameterName: "UIMinimumScaleFactor", tagName: "minimumScaleFactor"),
            DefaultParameterDecoder(parameterName: "UINumberOfLines", tagName: "numberOfLines"),
            DefaultParameterDecoder(parameterName: "UITag", tagName: "tag"),
            DefaultParameterDecoder(parameterName: "UIAlpha", tagName: "alpha")
            ])
        
        result.append(contentsOf: ListParameterDecoder.all())
        result.append(contentsOf: BoolParameterDecoder.all())
//        result.append(contentsOf: PointPropertySerializerParser.all())
//        result.append(contentsOf: FirstStringParser.all())
        
        
        return result
    }
    
    
    init(parameterName: String, tagName: String) {
        self.parameterName = parameterName
        self.tagName = tagName
        super.init()
    }
    
    func handledClassName() -> String {
        return "T.\(parameterName)-"
    }
    
    func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        if parameter.name == parameterName {
            let parameterValue = parameter.stringValue()
            
            let tagParameter = TagParameter(name: tagName, value: parameterValue)
            return .parameters([tagParameter], false)
        }
        
        return .empty(false)
    }
}
