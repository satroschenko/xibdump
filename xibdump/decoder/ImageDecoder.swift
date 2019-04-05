//
//  ImageDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/5/19.
//

import Cocoa

class ImageDecoder: NSObject, CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        return [
            "T.UIImage-UIImageNibPlaceholder",
            "T.UIHighlightedImage-UIImageNibPlaceholder",
            "T.UIMinimumValueImage-UIImageNibPlaceholder",
            "T.UIMaximumValueImage-UIImageNibPlaceholder",
            "T.UIBackgroundImage-UIImageNibPlaceholder"
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let value = object.findStringParameter(name: "UIResourceName", context: context) else {
            return .empty(false)
        }
        
        addImageToResourseSection(name: value, context: context)
        
        let param = TagParameter(name: parameter.name.xmlParameterName(), value: value)
        return .parameters([param], false)
    }
    
    
    fileprivate func addImageToResourseSection(name: String, context: ParserContext) {
        context.addImageResource(name: name)
    }
}
