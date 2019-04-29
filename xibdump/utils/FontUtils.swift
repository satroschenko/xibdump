//
//  FontUtils.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa

extension XibObject {
    
    func extractFontTag(tagName: String, key: String, context: ParserContext) -> Tag {
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: key)
        
        var styleFound = false
        
        if let style = findStringParameter(name: "UIIBTextStyle", context: context) {
            styleFound = true
            tag.addParameter(name: "style", value: "\(style)")
        }
        
        if !styleFound {
            if let name = findStringParameter(name: "UIFontName", context: context) {
                tag.addParameter(name: "name", value: "\(name)")
            }
            
            if let pointSize = findDoubleParameter(name: "UIFontPointSize", context: context) {
                tag.addParameter(name: "pointSize", value: "\(pointSize)")
            }
        }
        
        return tag
    }
}
