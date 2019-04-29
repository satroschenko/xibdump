//
//  PointTagDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class PointTagDecoder: NewTagDecoder {

    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            PointTagDecoder(parameterName: "UITitlePositionAdjustment",
                            objectClassName: "NSString",
                            tagName: "offsetWrapper",
                            needAddId: false,
                            mapper: nil,
                            keyParameter: "titlePositionAdjustment",
                            firstName: "horizontal",
                            secondName: "vertical"),
            
            PointTagDecoder(parameterName: "UISearchTextPositionAdjustment",
                            objectClassName: "NSString",
                            tagName: "offsetWrapper",
                            needAddId: false,
                            mapper: nil,
                            keyParameter: "searchTextPositionAdjustment",
                            firstName: "horizontal",
                            secondName: "vertical"),
            
            PointTagDecoder(parameterName: "UISearchFieldBackgroundPositionAdjustment",
                            objectClassName: "NSString",
                            tagName: "offsetWrapper",
                            needAddId: false,
                            mapper: nil,
                            keyParameter: "searchFieldBackgroundPositionAdjustment",
                            firstName: "horizontal",
                            secondName: "vertical")
        ]
    }
    
    let firstName: String
    let secondName: String
    
    init(parameterName: String,
         objectClassName: String,
         tagName: String,
         needAddId: Bool = true,
         mapper: [String: String]? = nil,
         keyParameter: String? = nil,
         firstName: String = "width",
         secondName: String = "height") {
        
        self.firstName = firstName
        self.secondName = secondName
        
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName, needAddId: needAddId, mapper: mapper, keyParameter: keyParameter)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let string = object.firstStringValue(with: context) else {
            return .empty(false)
        }
        
        
        let point = NSPointFromString(string)
        
        let tag = Tag(name: tagName)
        tag.addParameter(name: "key", value: keyParameter ?? parameter.name.xmlParameterName())
        
        tag.addParameter(name: firstName, value: "\(point.x)")
        tag.addParameter(name: secondName, value: "\(point.y)")
        
        return .tag(tag, false)
    }
}
