//
//  StoryboardConnectionDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/19/19.
//

import Cocoa
import AEXML
import SwiftCLI

struct StoryboardConnection {
    let fileName: String
    let storyboardIdentifier: String
    let rootClassName: String
}

class StoryboardConnectionDecoderHelper: NSObject {
    
    let context: ParserContext
    var storyboardName: String?
    
    init(xibFile: XibFile) {
        self.context = ParserContext(xibFile: xibFile, onlyNibParsing: false)
        super.init()
    }
    
    func findStoryboardConnections() -> [StoryboardConnection]? {
        
        var connections =  [StoryboardConnection]()
        
        context.clean()
        guard let firstObject = self.context.xibFile.xibObjects.first else {
            return connections
        }
        
        guard let topArray = firstObject.findObjectParameter(name: "UINibTopLevelObjectsKey", objectClass: "NSArray", context: context) else {
            return connections
        }
        
        let vcArray = topArray.getSubObjects(parameterName: "UINibEncoderEmptyKey", objectClassSuffix: "Controller", context: context)
        for oneVC in vcArray {
            
            if let connection = findConnection(object: oneVC, context: context) {
                connections.append(connection)
            }
        }
        
        return connections.isEmpty ? nil : connections
    }
    
    
    fileprivate func findConnection(object: XibObject, context: ParserContext) -> StoryboardConnection? {
        
        guard let nibName = object.findStringParameter(name: "UINibName", context: context) else {
            return nil
        }
        
        guard let stId = object.findStringParameter(name: "UIStoryboardIdentifier", context: context) else {
            return nil
        }
        
        let rootClassName = object.originalClassName(context: context).systemParameterName()
        return StoryboardConnection(fileName: nibName, storyboardIdentifier: stId, rootClassName: rootClassName)
    }
}
