//
//  WebViewConfigurationDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class WebViewConfigurationDecoder: NSObject, CustomTagDecoderProtocol {

    override init() {
        super.init()
    }
    
    func handledClassNames() -> [String] {
        return ["T.configuration-WKWebViewConfiguration"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "wkWebViewConfiguration")
        tag.addParameter(name: "key", value: "configuration")
        
        if let name = object.findStringParameter(name: "applicationNameForUserAgent", context: context) {
            tag.addParameter(name: "applicationNameForUserAgent", value: name)
        }
        
        if let selGr = object.findIntParameter(name: "selectionGranularity", context: context) {
            if selGr == 1 {
                tag.addParameter(name: "selectionGranularity", value: "character")
            }
        }
        
        if let prefObject = object.findObjectParameter(name: "preferences", context: context) {
            
            let prefTag = Tag(name: "wkPreferences")
            prefTag.addParameter(name: "key", value: "preferences")
            tag.add(tag: prefTag)
            
            if let size = prefObject.findDoubleParameter(name: "minimumFontSize", context: context) {
                prefTag.addParameter(name: "minimumFontSize", value: "\(size)")
            }
            
            addBoolTag(object: prefObject, name: "javaScriptEnabled", parameter: "javaScriptEnabled", context: context, tag: prefTag)
            addBoolTag(object: prefObject,
                       name: "javaScriptCanOpenWindowsAutomatically",
                       parameter: "javaScriptCanOpenWindowsAutomatically",
                       context: context,
                       tag: prefTag)
        }
        
        
        addBoolTag(object: object, name: "allowsAirPlayForMediaPlayback", parameter: "allowsAirPlayForMediaPlayback", context: context, tag: tag)
        addBoolTag(object: object, name: "allowsInlineMediaPlayback", parameter: "allowsInlineMediaPlayback", context: context, tag: tag)
        addBoolTag(object: object, name: "allowsPictureInPictureMediaPlayback", parameter: "allowsPictureInPictureMediaPlayback", context: context, tag: tag)
        
        addBoolTag(object: object, name: "allowsInlineMediaPlayback", parameter: "allowsInlineMediaPlayback", context: context, tag: tag)
        addBoolTag(object: object, name: "allowsInlineMediaPlayback", parameter: "allowsInlineMediaPlayback", context: context, tag: tag)
        
        let visualTag = Tag(name: "audiovisualMediaTypes")
        visualTag.addParameter(name: "key", value: "mediaTypesRequiringUserActionForPlayback")
        tag.add(tag: visualTag)
        
        let visuaTagValue = object.findBoolParameter(name: "mediaTypesRequiringUserActionForPlayback", context: context) ?? false
        if visuaTagValue {
            visualTag.addParameter(name: "audio", value: "YES")
            visualTag.addParameter(name: "video", value: "YES")
        } else {
            visualTag.addParameter(name: "none", value: "YES")
        }
        
        if let detectorTypes = object.findIntParameter(name: "dataDetectorTypes", context: context) {
            
            let typesTag = Tag(name: "dataDetectorTypes")
            typesTag.addParameter(name: "key", value: "dataDetectorTypes")
            tag.add(tag: typesTag)
            
            DataDetectorTypesDecoder.decode(value: detectorTypes, context: context, tag: typesTag)
        }
        
        return .tag(tag, true)
    }
    
    
    fileprivate func addBoolTag(object: XibObject, name: String, parameter: String, context: ParserContext, tag: Tag) {
        if let isTag = object.findBoolParameter(name: name, context: context) {
            tag.addParameter(name: parameter, value: isTag ? "YES" : "NO")
        }
    }
}
