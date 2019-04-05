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
            "T.UIMaximumValueImage-UIImageNibPlaceholder"
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
        
        let tag = Tag(name: "image")
        tag.addParameter(name: "name", value: name)
        tag.addParameter(name: "width", value: "16")
        tag.addParameter(name: "height", value: "16")
        
        context.imageResources.append(tag)
    }
}
