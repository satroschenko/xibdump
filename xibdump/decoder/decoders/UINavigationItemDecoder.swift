//
//  UINavigationItemDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class UINavigationItemDecoder: NewTagDecoder {
    
    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            UINavigationItemDecoder(parameterName: "UINibEncoderEmptyKey",
                                    objectClassName: "UINavigationItem",
                                    tagName: "navigationItem",
                                    needAddId: true,
                                    mapper: nil,
                                    keyParameter: nil)
        ]
    }


    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        
        if case let .tag(tag, _) = result {
            
            guard let object = parameter.object(with: context) else {
                return result
            }
            
            if let leftItemsObject = object.findObjectParameter(name: "UILeftBarButtonItems", objectClass: "NSArray", context: context) {
                
                let itemsTag = Tag(name: "leftBarButtonItems")
                tag.add(tag: itemsTag)
                
                for obj in leftItemsObject.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "UIBarButtonItem", context: context) {
                    
                    let itemTag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: obj, context: context, key: nil)
                    itemsTag.add(tag: itemTag)
                }
                
            } else if let leftItemObject = object.findObjectParameter(name: "UILeftBarButtonItem", objectClass: "UIBarButtonItem", context: context) {
            
                let itemTag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: leftItemObject, context: context, key: "leftBarButtonItem")
                tag.add(tag: itemTag)
            }
            
            
            if let fightItemsObject = object.findObjectParameter(name: "UIRightBarButtonItems", objectClass: "NSArray", context: context) {
                
                let itemsTag = Tag(name: "rightBarButtonItems")
                tag.add(tag: itemsTag)
                
                for obj in fightItemsObject.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "UIBarButtonItem", context: context) {
                    
                    let itemTag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: obj, context: context, key: nil)
                    itemsTag.add(tag: itemTag)
                }
                
            } else if let rightItemObject = object.findObjectParameter(name: "UIRightBarButtonItem", objectClass: "UIBarButtonItem", context: context) {
                
                let itemTag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: rightItemObject, context: context, key: "rightBarButtonItem")
                tag.add(tag: itemTag)
            }
            
            if let backItemObject = object.findObjectParameter(name: "UIBackBarButtonItem", objectClass: "UIBarButtonItem", context: context) {
                
                let itemTag = UINavigationItemDecoder.extractItemTag(parentObject: parentObject, object: backItemObject, context: context, key: "backBarButtonItem")
                tag.add(tag: itemTag)
            }
            
            return .tag(tag, false)
            
        }
        
        return result
    }
    
    
    static func extractItemTag(parentObject: XibObject, object: XibObject, context: ParserContext, key: String?) -> Tag {
        
        let tag = Tag(name: "barButtonItem")
        tag.addParameter(name: "id", value: object.objectId)
        tag.innerObjectId = object.objectId
        
        if let key = key {
            tag.addParameter(name: "key", value: key)
        }
        
        if let style = object.findIntParameter(name: "UIStyle", context: context) {
            let styles = ["plain", "bordered", "done"]
            tag.addParameter(name: "style", value: styles[safe: style] ?? "plain")
        }
        
        if let color = object.findObjectParameter(name: "UITintColor", objectClass: "UIColor", context: context) {
            
            let colorTag = UIColorDecoder.extractColorTag(parentObject: object, object: color, tagName: "color", parameterName: "tintColor", context: context)
            tag.add(tag: colorTag)
        }
        
        extractBool(object: object, name: "UISpringLoaded", parameter: "springLoaded", context: context, tag: tag)
        extractBool(object: object, name: "UIEnabled", parameter: "enabled", context: context, tag: tag)
        
        if let title = object.findStringParameter(name: "UITitle", context: context) {
            tag.addParameter(name: "title", value: title)
        }
        
        extractImage(object: object, name: "UIImage", objectClass: "UIImageNibPlaceholder", parameterName: "image", context: context, tag: tag)
        extractImage(object: object, name: "UILandscapeImagePhone", objectClass: "UIImageNibPlaceholder", parameterName: "landscapeImage", context: context, tag: tag)
        extractImage(object: object, name: "_UIBarItemLargeContentSizeImageCodingKey",
                     objectClass: "UIImageNibPlaceholder",
                     parameterName: "largeContentSizeImage",
                     context: context,
                     tag: tag)
        
        if let uiTag = object.findIntParameter(name: "UITag", context: context) {
            tag.addParameter(name: "tag", value: "\(uiTag)")
        }
        
        if let systemItem = object.findIntParameter(name: "UISystemItem", context: context) {
            let items = ["done", "cancel", "edit", "save", "add", "flexibleSpace", "fixedSpace", "compose", "reply", "action", "organize",
                         "bookmarks", "search", "refresh", "stop", "camera", "trash", "play", "pause", "rewind", "fastForward",
                         "undo", "redo", "pageCurl"]
            if let value = items[safe: systemItem] {
                tag.addParameter(name: "systemItem", value: value)
            }
        }
        
        return tag
    }
    
    static func extractImage(object: XibObject, name: String, objectClass: String, parameterName: String, context: ParserContext, tag: Tag) {
        
        if let image = object.findObjectParameter(name: name, objectClass: objectClass, context: context) {
            
            if let value = image.findStringParameter(name: "UIResourceName", context: context) {
                tag.addParameter(name: parameterName, value: value)
                ImageDecoder.addImageToResourseSection(name: value, context: context)
            }
        }
    }
    
    static func extractBool(object: XibObject, name: String, parameter: String, context: ParserContext, tag: Tag) {
        if let isTag = object.findBoolParameter(name: name, context: context) {
            tag.addParameter(name: parameter, value: isTag ? "YES" : "NO")
        }
    }
}
