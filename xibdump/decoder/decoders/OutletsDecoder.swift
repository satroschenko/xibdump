//
//  OutletsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/12/19.
//

import Cocoa

class OutletsDecoder: NSObject, CustomTagDecoderProtocol {

    struct EventMaskOptionSet: OptionSet {
        
        let rawValue: Int
        
        static let touchDown                    = EventMaskOptionSet(rawValue: 1 << 0) // 1
        static let touchDownRepeat              = EventMaskOptionSet(rawValue: 1 << 1) // 2
        static let touchDragInside              = EventMaskOptionSet(rawValue: 1 << 2) // 4
        static let touchDragOutside             = EventMaskOptionSet(rawValue: 1 << 3) // 8
        static let touchDragEnter               = EventMaskOptionSet(rawValue: 1 << 4) // 16
        static let touchDragExit                = EventMaskOptionSet(rawValue: 1 << 5) // 32
        static let touchUpInside                = EventMaskOptionSet(rawValue: 1 << 6) // 64
        static let touchUpOutside               = EventMaskOptionSet(rawValue: 1 << 7) // 128
        static let touchCancel                  = EventMaskOptionSet(rawValue: 1 << 8) // 256
                                                                                        // 512
                                                                                        // 1024
                                                                                        // 2048
        static let valueChanged                 = EventMaskOptionSet(rawValue: 1 << 12) // 4096
        static let primaryActionTriggered       = EventMaskOptionSet(rawValue: 1 << 13) // 8192
                                                                                        // 16000
                                                                                        // 32000
        static let editingDidBegin              = EventMaskOptionSet(rawValue: 1 << 16) // 65536
        static let editingChanged               = EventMaskOptionSet(rawValue: 1 << 17) // 131072
        static let editingDidEnd                = EventMaskOptionSet(rawValue: 1 << 18) // 262144
        static let editingDidEndOnExit          = EventMaskOptionSet(rawValue: 1 << 19) // 524288
    }
    
    func handledClassNames() -> [String] {
        return ["A.UINibConnectionsKey-NSArray"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        let outletConnections = object.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "UIRuntimeOutletConnection", context: context)
        for connection in outletConnections {
            parseOneConnection(object: connection, context: context)
        }
        
        
        let outletCollectionConnections = object.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "UIRuntimeOutletCollectionConnection", context: context)
        for connection in outletCollectionConnections {
            parseCollectionConnection(object: connection, context: context)
        }
        
        let eventConnections = object.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClass: "UIRuntimeEventConnection", context: context)
        for connection in eventConnections {
            parseEventConnection(object: connection, context: context)
        }
        
        return .empty(false)
    }
    
    
    fileprivate func parseOneConnection(object: XibObject, context: ParserContext) {
        
        guard let parentTag = findSourceTag(object: object, context: context) else {
            return
        }
        
        guard let outletName = findOutletName(object: object, context: context) else {
            return
        }
        
        guard let destination = object.findObjectParameter(name: "UIDestination", context: context) else {
            return
        }
        
        let outletTag = Tag(name: "outlet")
        outletTag.addParameter(name: "id", value: object.objectId)
        outletTag.addParameter(name: "property", value: outletName)
        outletTag.addParameter(name: "destination", value: destination.objectId)
        
        
        var connectionsTag = Tag(name: "connections")
        if let found = parentTag.allChildren().filter({$0.name == "connections"}).first {
            connectionsTag = found
        } else {
            parentTag.add(tag: connectionsTag)
        }
        
        connectionsTag.add(tag: outletTag)
    }
    
    fileprivate func parseCollectionConnection(object: XibObject, context: ParserContext) {
        
        guard let parentTag = findSourceTag(object: object, context: context) else {
            return
        }
        
        guard let outletName = findOutletName(object: object, context: context) else {
            return
        }
        
        guard let destinations = object.findObjectParameter(name: "UIDestination", context: context) else {
            return
        }
        
        var connectionsTag = Tag(name: "connections")
        if let found = parentTag.allChildren().filter({$0.name == "connections"}).first {
            connectionsTag = found
        } else {
            parentTag.add(tag: connectionsTag)
        }
        
        for param in destinations.parameters(with: context) where param.name == "UINibEncoderEmptyKey" {
            if let destObject = param.object(with: context) {
                let outletTag = Tag(name: "outletCollection")
                outletTag.addParameter(name: "id", value: XibID.generate())
                outletTag.addParameter(name: "property", value: outletName)
                outletTag.addParameter(name: "destination", value: destObject.objectId)
                
                connectionsTag.add(tag: outletTag)
            }
        }
    }
    
    // swiftlint:disable all
    fileprivate func parseEventConnection(object: XibObject, context: ParserContext) {
        
        guard let parentTag = findSourceTag(object: object, context: context) else {
            return
        }
        
        guard let selectorName = findOutletName(object: object, context: context) else {
            return
        }
        
        guard let destination = object.findObjectParameter(name: "UIDestination", context: context) else {
            return
        }
        
        guard let destinationTag = context.findTag(objectId: destination.objectId) else {
            return
        }
        
        guard let eventMask = object.findIntParameter(name: "UIEventMask", context: context) else {
            return
        }
        
        let actionTag = Tag(name: "action")
        actionTag.addParameter(name: "id", value: object.objectId)
        actionTag.addParameter(name: "selector", value: selectorName)
        actionTag.addParameter(name: "destination", value: getDestinationId(object: destination, tag: destinationTag))
        
        let optionSet = EventMaskOptionSet(rawValue: eventMask)
        
        if optionSet.contains(.touchDown) {
            actionTag.addParameter(name: "eventType", value: "touchDown")
        }
        if optionSet.contains(.touchDownRepeat) {
            actionTag.addParameter(name: "eventType", value: "touchDownRepeat")
        }
        if optionSet.contains(.touchDragInside) {
            actionTag.addParameter(name: "eventType", value: "touchDragInside")
        }
        if optionSet.contains(.touchDragOutside) {
            actionTag.addParameter(name: "eventType", value: "touchDragOutside")
        }
        if optionSet.contains(.touchDragEnter) {
            actionTag.addParameter(name: "eventType", value: "touchDragEnter")
        }
        if optionSet.contains(.touchDragExit) {
            actionTag.addParameter(name: "eventType", value: "touchDragExit")
        }
        if optionSet.contains(.touchUpInside) {
            actionTag.addParameter(name: "eventType", value: "touchUpInside")
        }
        if optionSet.contains(.touchUpOutside) {
            actionTag.addParameter(name: "eventType", value: "touchUpOutside")
        }
        if optionSet.contains(.touchCancel) {
            actionTag.addParameter(name: "eventType", value: "touchCancel")
        }
        if optionSet.contains(.valueChanged) {
            actionTag.addParameter(name: "eventType", value: "valueChanged")
        }
        if optionSet.contains(.primaryActionTriggered) {
            actionTag.addParameter(name: "eventType", value: "primaryActionTriggered")
        }
        if optionSet.contains(.editingDidBegin) {
            actionTag.addParameter(name: "eventType", value: "editingDidBegin")
        }
        if optionSet.contains(.editingChanged) {
            actionTag.addParameter(name: "eventType", value: "editingChanged")
        }
        if optionSet.contains(.editingDidEnd) {
            actionTag.addParameter(name: "editingDidEnd", value: "editingDidEnd")
        }
        if optionSet.contains(.editingDidEndOnExit) {
            actionTag.addParameter(name: "eventType", value: "editingDidEndOnExit")
        }
        
        
        var connectionsTag = Tag(name: "connections")
        if let found = parentTag.allChildren().filter({$0.name == "connections"}).first {
            connectionsTag = found
        } else {
            parentTag.add(tag: connectionsTag)
        }
        
        connectionsTag.add(tag: actionTag)
    }
    // swiftlint:enable all
    
    fileprivate func findSourceTag(object: XibObject, context: ParserContext) -> Tag? {
        
        guard let source = object.findObjectParameter(name: "UISource", context: context) else {
            return nil
        }
        
        guard let sourceTag = context.findTag(objectId: source.objectId) else {
            return nil
        }
        
        return sourceTag
    }
    
    fileprivate func findOutletName(object: XibObject, context: ParserContext) -> String? {
        
        if let propertyObj = object.findFirstObjectParameter(objectClass: "NSString", context: context),
            let property = propertyObj.firstStringValue(with: context) {
            
            return property
        }
        return nil
    }
    
    fileprivate func getDestinationId(object: XibObject, tag: Tag) -> String {
        
        if let idString = tag.parameterValue(name: "id") {
            return idString
        }
        
        return object.objectId
    }
}
