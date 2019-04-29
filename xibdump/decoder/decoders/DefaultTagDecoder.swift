//
//  NewTagParser.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class DefaultTagDecoder: NSObject, TagDecoderProtocol {
    
    let parameterName: String
    let objectClassName: String
    let tagName: String
    var needAddId: Bool = true
    let tagMapper: [String: String]?
    let keyParameter: String?
    let keyMapper: [String: String]?
    var topLevelDecoder: Bool = true
    
    init(parameterName: String,
         objectClassName: String,
         tagName: String,
         needAddId: Bool = true,
         tagMapper: [String: String]? = nil,
         keyParameter: String? = nil,
         keyMapper: [String: String]? = nil) {
        
        self.parameterName = parameterName
        self.objectClassName = objectClassName
        self.tagName = tagName
        self.needAddId = needAddId
        self.tagMapper = tagMapper
        self.keyParameter = keyParameter
        self.keyMapper = keyMapper
        super.init()
    }
    
    convenience init(uiKitName: String) {
        self.init(parameterName: "UINibEncoderEmptyKey",
                  objectClassName: uiKitName,
                  tagName: uiKitName.systemParameterName(),
                  needAddId: true)
    }
    
    func handledClassNames() -> [String] {
        return [Utils.decoderKey(parameterName: parameterName, className: objectClassName, isTopLevel: topLevelDecoder)]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard parameter.name == self.parameterName else {
            return .empty(true)
        }
        
        guard let object = parameter.object(with: context) else {
            return .empty(true)
        }
        
        if !self.objectClassName.isEmpty {
          
            guard object.originalClassName(context: context) == self.objectClassName else {
                return .empty(true)
            }
        }
        
        var finalTagName = tagName
        if let tagMapper = tagMapper {
            let parentClassName = parentObject.originalClassName(context: context)
            if let newTag = tagMapper[parentClassName] {
                finalTagName = newTag
            }
        }
        
        if finalTagName.isEmpty {
            return .empty(true)
        }
        
        let newTag = Tag(name: finalTagName)
        if self.needAddId {
            newTag.add(parameter: TagParameter(name: "id", value: object.objectId))
        }
    
        newTag.add(tags: self.additianalChildTags())
        newTag.add(parameters: self.additianalChildParams())
        newTag.innerObjectId = object.objectId
        
        if var key = keyParameter {
            if let keyMapper = keyMapper {
                if let newKey = keyMapper[key] {
                    key = newKey
                }
            }
            
            newTag.addParameter(name: "key", value: key)
        }
    
        return .tag(newTag, true)
    }
    
    
    func additianalChildTags() -> [Tag] {
        return []
    }
    
    func additianalChildParams() -> [TagParameter] {
        return []
    }
}
