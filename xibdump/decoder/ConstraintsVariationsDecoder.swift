//
//  ConstraintsVariationsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class ConstraintsVariationsDecoder: NSObject, CustomTagDecoderProtocol {

    func handledClassNames() -> [String] {
        
        return [
            "A.UINibTraitStorageListsKey-NSMutableArray",
            "A.UINibTraitStorageListsKey-NSArray"
        ]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let arrayObject = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let traitStorageList = arrayObject.findObjectParameter(name: "UINibEncoderEmptyKey",
                                                                     objectClass: "_UITraitStorageList",
                                                                     context: context) else {
            return .empty(false)
        }
        
        guard let traitStorageArray = traitStorageList.findObjectParameter(name: "UITraitStorages", objectClass: "NSArray", context: context) else {
            return .empty(false)
        }
        
        
        let attributeStorageArray = traitStorageArray.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                                    objectClass: "_UIAttributeTraitStorage",
                                                                    context: context)
        
        for attributeStorage in attributeStorageArray {
            parseAttributeStorage(object: attributeStorage, context: context)
        }
        
        
        let relationshipStorageArray = traitStorageArray.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                                       objectClass: "_UIRelationshipTraitStorage",
                                                                       context: context)
        
        for relationshipStorage in relationshipStorageArray {
            parseRelationshipStorage(object: relationshipStorage, context: context)
        }
        
     
        return .empty(false)
    }
    
    
    fileprivate func parseAttributeStorage(object: XibObject, context: ParserContext) {
        
        guard let constraintObject = object.findObjectParameter(name: "UIObject", objectClass: "NSLayoutConstraint", context: context) else {
            return
        }
        
        guard let constraintTag = context.constrains[constraintObject.objectId] else {
            return
        }
        
        guard let recordsArrayObject = object.findObjectParameter(name: "UIRecords", objectClass: "NSMutableArray", context: context) else {
            return
        }
        
        let recordsArray = recordsArrayObject.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "_UIAttributeTraitStorageRecord",
                                                            context: context)
        
        for oneRecord in recordsArray {
            parseRecord(object: oneRecord, context: context, parentTag: constraintTag)
        }
    }
    
    fileprivate func parseRecord(object: XibObject, context: ParserContext, parentTag: Tag) {
        
        guard let traintCollectionObject = object.findObjectParameter(name: "UITraitCollection",
                                                                      objectClass: "UITraitCollection",
                                                                      context: context) else {
            return
        }
        
        guard let constantObject = object.findObjectParameter(name: "UIValue",
                                                              objectClass: "_NSLayoutConstraintConstant",
                                                              context: context) else {
                                                                
            return
        }
        
        guard let doubleConstant = constantObject.findDoubleParameter(name: "UINumericConstant", context: context) else {
            return
        }
        
        var variations = [String: Int]()
        
        for param in traintCollectionObject.parameters(with: context) {
            
            if let intParam = param as? XibIntParameter {
            
                let name = intParam.name
                variations[name] = intParam.value
            }
        }
        
        if variations.count > 0 {
            let subTag = Tag(name: "variation")
            subTag.addParameter(name: "constant", value: "\(doubleConstant)")
            subTag.addParameter(name: "key", value: createVariationName(keys: variations))
            
            parentTag.add(tag: subTag)
        }
    }
    
    
    fileprivate func parseRelationshipStorage(object: XibObject, context: ParserContext) {
        
        guard let viewObject = object.findObjectParameter(name: "UIObject", objectClass: "UIView", context: context) else {
            return
        }
        
        guard let recordsArrayObject = object.findObjectParameter(name: "UIRecords", objectClass: "NSMutableArray", context: context) else {
            return
        }
        
        let recordsArray = recordsArrayObject.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "_UIRelationshipTraitStorageRecord",
                                                            context: context)
        
        for oneRecord in recordsArray {
            parseRelationshipRecord(object: oneRecord, context: context, viewObjectId: viewObject.objectId)
        }
    }
    
    
    fileprivate func parseRelationshipRecord(object: XibObject, context: ParserContext, viewObjectId: String) {
        
        guard let traintCollectionObject = object.findObjectParameter(name: "UITraitCollection",
                                                                      objectClass: "UITraitCollection",
                                                                      context: context) else {
                                                                        return
        }
        
        guard let addedObjects = object.findObjectParameter(name: "UIAddedObjects",
                                                            objectClass: "NSSet",
                                                            context: context) else {
                                                                
                                                                return
        }
        
        guard let removedObjects = object.findObjectParameter(name: "UIRemovedObjects",
                                                              objectClass: "NSSet",
                                                              context: context) else {
                                                                
                                                                return
        }
        
        
        var variations = [String: Int]()
        
        for param in traintCollectionObject.parameters(with: context) {
            
            if let intParam = param as? XibIntParameter {
                
                let name = intParam.name
                variations[name] = intParam.value
            }
        }
        
        if variations.count > 0 {
            
            let variationTag = Tag(name: "variation")
            variationTag.addParameter(name: "key", value: createVariationName(keys: variations))
            let maskTag = Tag(name: "mask")
            maskTag.addParameter(name: "key", value: "constraints")
            variationTag.add(tag: maskTag)
            
            let includedList = addedObjects.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "NSLayoutConstraint", context: context)
            for one in includedList {
                let includeTag = Tag(name: "include")
                includeTag.addParameter(name: "reference", value: one.objectId)
                maskTag.add(tag: includeTag)
            }
            
            let excludedList = removedObjects.getSubObjects(parameterName: "UINibEncoderEmptyKey",
                                                            objectClass: "NSLayoutConstraint",
                                                            context: context)
            for one in excludedList {
                let excludeTag = Tag(name: "exclude")
                excludeTag.addParameter(name: "reference", value: one.objectId)
                maskTag.add(tag: excludeTag)
            }
            
            var tagsArray = context.variations[viewObjectId]
            if tagsArray == nil {
                tagsArray = [Tag]()
            }
            
            tagsArray?.append(variationTag)
            context.variations[viewObjectId] = tagsArray
        }
    }
    
    
    fileprivate func createVariationName(keys: [String: Int]) -> String {
        
        var result: [String] = [String]()
        for (key, value) in keys {
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameDisplayGamut" {
                if value == 0 {
                    result.append("displayGamut=sRGB")
                }
                
                if value == 1 {
                    result.append("displayGamut=P3")
                }
            }
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameHorizontalSizeClass" {
                if value == 1 {
                    result.append("widthClass=regular")
                }
                if value == 2 {
                    result.append("widthClass=compact")
                }
            }
            
            if key == "UITraitCollectionBuiltinTrait-_UITraitNameVerticalSizeClass" {
                if value == 1 {
                    result.append("heightClass=regular")
                }
                if value == 2 {
                    result.append("heightClass=compact")
                }
            }
        }
        
        
        return result.joined(separator: "-")
    }
}
