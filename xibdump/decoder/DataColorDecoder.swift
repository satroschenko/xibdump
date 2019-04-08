//
//  DataColorDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/8/19.
//

import Cocoa

class DataColorDecoder: NSObject, CustomTagDecoderProtocol {

    let parameterName: String
    let objectName: String
    let tagName: String
    let key: String
    
    init(parameterName: String, objectName: String = "NSData", tagName: String = "color", key: String = "clearColor") {
        self.parameterName = parameterName
        self.objectName = objectName
        self.tagName = tagName
        self.key = key
        super.init()
    }
    
    func handledClassNames() -> [String] {
        return ["T.\(parameterName)-\(objectName)"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard let data = object.findDataParameter(name: "NS.bytes", context: context) else {
            return .empty(false)
        }
        
        do {
            
            let stream = DataStream(with: data as NSData)
            let red = try stream.readDouble()
            let green = try stream.readDouble()
            let blue = try stream.readDouble()
            let alpha = try stream.readDouble()
            
           
            let tag = Tag(name: tagName)
            tag.addParameter(name: "key", value: key)
            tag.addParameter(name: "colorSpace", value: "custom")
            tag.addParameter(name: "customColorSpace", value: "sRGB")
            tag.addParameter(name: "red", value: "\(red)")
            tag.addParameter(name: "green", value: "\(green)")
            tag.addParameter(name: "blue", value: "\(blue)")
            tag.addParameter(name: "alpha", value: "\(alpha)")
            
            return .tag(tag, false)
            
            
        } catch {}
        
        return .empty(false)
    }
}
