//
//  NewTagParser.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class NewTagDecoder: NSObject, CustomTagDecoderProtocol {
    
    let parameterName: String
    let objectClassName: String
    let tagName: String
    var needAddId: Bool = true
    
    init(parameterName: String, objectClassName: String, tagName: String, needAddId: Bool = true) {
        self.parameterName = parameterName
        self.objectClassName = objectClassName
        self.tagName = tagName
        self.needAddId = needAddId
        super.init()
    }
    
    func handledClassNames() -> [String] {
        return ["T.\(parameterName)-\(objectClassName)"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard parameter.name == self.parameterName else {
            return .empty(true)
        }
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        if !self.objectClassName.isEmpty {
          
            guard object.xibClass.name == self.objectClassName else {
                return .empty(true)
            }
        }
        
        let newTag = Tag(name: self.tagName)
        if self.needAddId {
            newTag.add(parameter: TagParameter(name: "id", value: object.objectId))
        }
    
        newTag.add(tags: self.additianalChildTags())
        newTag.add(parameters: self.additianalChildParams())
        newTag.innerObjectId = object.objectId
    
        return .tag(newTag, true)
    }
    
    
    func additianalChildTags() -> [Tag] {
        return []
    }
    
    func additianalChildParams() -> [TagParameter] {
        return []
    }
}
