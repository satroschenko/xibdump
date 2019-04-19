//
//  PlaceholderDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class PlaceholderDecoder: NewTagDecoder {

    init() {
        super.init(parameterName: "UIProxiedObjectIdentifier",
                   objectClassName: "NSString",
                   tagName: "placeholder",
                   needAddId: false)
    }
    
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let name = object.firstStringValue(with: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "placeholder")
        tag.addParameter(name: "placeholderIdentifier", value: name)
        
        if name == "IBFilesOwner" {
            tag.addParameter(name: "id", value: "-1")
            tag.addParameter(name: "userLabel", value: "File's Owner")
        
        } else if name == "IBFirstResponder" {
            tag.addParameter(name: "id", value: "-2")
            tag.addParameter(name: "userLabel", value: "First Responder")
        
        } else {
            tag.addParameter(name: "id", value: object.objectId)
        }
        
        tag.innerObjectId = parentObject.objectId
        
        return .tag(tag, false)
    }
}
