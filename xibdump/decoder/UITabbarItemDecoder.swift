//
//  UITabbarItemDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class UITabbarItemDecoder: CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        return ["T.UINibEncoderEmptyKey-UITabBarItem"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let tag = Tag(name: "tabBarItem")
        tag.addParameter(name: "id", value: object.objectId)
        tag.innerObjectId = object.objectId
        
        
        
        return .tag(tag, true)
    }
}
