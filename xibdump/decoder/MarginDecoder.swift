//
//  MarginDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/2/19.
//

import Cocoa

class MarginDecoder: DefaultParameterDecoder {

    init() {
        super.init(parameterName: "UIViewLayoutMargins", tagName: "edgeInsets")
    }
    
    override func handledClassNames() -> [String] {
        return ["T.\(parameterName)-"]
    }
    
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let dataParameter = parameter as? XibDataParameter else {
            return .empty(false)
        }
        
        let isDirectional = parentObject.findBoolParameter(name: "UIViewLayoutMarginsAreDirectional", context: context) ?? false
        
        do {
            
            let stream = DataStream(with: dataParameter.value as NSData)
            stream.position = 1
            let top = try stream.readDouble()
            let left = try stream.readDouble()
            let bottom = try stream.readDouble()
            let right = try stream.readDouble()
            
            
            let tag = Tag(name: isDirectional ? "directionalEdgeInsets" : "edgeInsets")
            tag.addParameter(name: "key", value: isDirectional ? "directionalLayoutMargins" : "layoutMargins")
            
            tag.addParameter(name: "top", value: "\(top)")
            tag.addParameter(name: "left", value: "\(left)")
            tag.addParameter(name: "bottom", value: "\(bottom)")
            tag.addParameter(name: "right", value: "\(right)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
