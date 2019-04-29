//
//  WebViewConfigurationDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class WebViewConfigurationDecoder: NSObject, TagDecoderProtocol {

    override init() {
        super.init()
    }
    
    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: "configuration", className: "WKWebViewConfiguration", isTopLevel: true)]
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
            
            prefTag.addBoolParameter(object: prefObject, name: "javaScriptEnabled", context: context, tagName: "javaScriptEnabled")
            prefTag.addBoolParameter(object: prefObject, name: "javaScriptCanOpenWindowsAutomatically", context: context, tagName: "javaScriptCanOpenWindowsAutomatically")
        }
        
        
        tag.addBoolParameter(object: object, name: "allowsAirPlayForMediaPlayback", context: context, tagName: "allowsAirPlayForMediaPlayback")
        tag.addBoolParameter(object: object, name: "allowsInlineMediaPlayback", context: context, tagName: "allowsInlineMediaPlayback")
        tag.addBoolParameter(object: object, name: "allowsPictureInPictureMediaPlayback", context: context, tagName: "allowsPictureInPictureMediaPlayback")
        
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
            
            typesTag.extractDataDetectorType(value: detectorTypes)
        }
        
        return .tag(tag, true)
    }
}
