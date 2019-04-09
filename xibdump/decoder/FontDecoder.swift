//
//  FontDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class FontDecoder: NSObject, CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        return [
            "T.UIFont-UIFont",
            "T.UINibEncoderEmptyKey-UIFont"
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "fontDescription")
        tag.addParameter(name: "key", value: "fontDescription")
        
        var styleFound = false
        
        if let style = object.findStringParameter(name: "UIIBTextStyle", context: context) {
            styleFound = true
            tag.addParameter(name: "style", value: "\(style)")
        }
        
        if !styleFound {
            if let name = object.findStringParameter(name: "UIFontName", context: context) {
                tag.addParameter(name: "name", value: "\(name)")
            }
            
            if let pointSize = object.findDoubleParameter(name: "UIFontPointSize", context: context) {
                tag.addParameter(name: "pointSize", value: "\(pointSize)")
            }
        }
        
        return .tag(tag, false)
    }
}
