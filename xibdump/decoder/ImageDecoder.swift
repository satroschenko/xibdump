//
//  ImageDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/5/19.
//

import Cocoa

class ImageDecoder: NSObject, CustomTagDecoderProtocol {
    
    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            ImageDecoder(parameterName: "UIImage"),
            ImageDecoder(parameterName: "UIHighlightedImage"),
            ImageDecoder(parameterName: "UIMinimumValueImage"),
            ImageDecoder(parameterName: "UIMaximumValueImage"),
            ImageDecoder(parameterName: "UIBackgroundImage"),
            ImageDecoder(parameterName: "UISegmentInfo", key: "image"),
            ImageDecoder(parameterName: "UITextFieldBackground", key: "background"),
            ImageDecoder(parameterName: "UITextFieldDisabledBackground", key: "disabledBackground"),
            ImageDecoder(parameterName: "UIShadowImage"),
            ImageDecoder(parameterName: "UIBackIndicatorImage"),
            ImageDecoder(parameterName: "UIBackIndicatorTransitionMask"),
            ImageDecoder(parameterName: "UISelectionIndicatorImage"),
            ImageDecoder(parameterName: "_UIBarItemLargeContentSizeImageCodingKey", key: "largeContentSizeImage"),
            ImageDecoder(parameterName: "UISelectedTemplateImage", key: "selectedImage"),
            ImageDecoder(parameterName: "UIImageLandscape", key: "landscapeImage")
        ]
    }
    
    let parameterName: String
    let key: String?
    
    init(parameterName: String, key: String? = nil) {
        self.parameterName = parameterName
        self.key = key
        super.init()
    }
    

    func handledClassNames() -> [String] {
        return ["T.\(parameterName)-UIImageNibPlaceholder"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let value = object.findStringParameter(name: "UIResourceName", context: context) else {
            return .empty(false)
        }
        
        ImageDecoder.addImageToResourseSection(name: value, context: context)
        
        let param = TagParameter(name: key ?? parameter.name.xmlParameterName(), value: value)
        return .parameters([param], false)
    }
    
    
    static func addImageToResourseSection(name: String, context: ParserContext) {
        context.addImageResource(name: name)
    }
}
