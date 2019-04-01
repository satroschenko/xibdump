//
//  NewTagParser.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class NewTagParser: NSObject, CustomTagProtocol {
    
    let xibClassName: String
    let tagName: String
    var needAddId: Bool = true
    
    init(xibClassName: String, tagName: String, needAddId: Bool = true) {
        self.xibClassName = xibClassName
        self.tagName = tagName
        self.needAddId = needAddId
        super.init()
    }
    
    func handledClassName() -> String {
        return xibClassName
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty
        }
        
        if parameter.name == self.xibClassName || object.xibClass.name == self.xibClassName {
            
            let newTag = Tag(name: self.tagName)
            if self.needAddId {
                newTag.add(parameter: TagParameter(name: "id", value: object.objectId))
            }
            
            newTag.add(tags: self.additianalChildTags())
            newTag.add(parameters: self.additianalChildParams())
            
            return .beginNewTag(newTag)
        }
        
        return .empty
    }
    
    
    func additianalChildTags() -> [Tag] {
        return []
    }
    
    func additianalChildParams() -> [TagParameter] {
        return []
    }
}
