//
//  ShadowOffsetDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class SizeTagDecoder: NewTagDecoder {
    
    let key: String?
    
    init(parameterName: String, key: String? = nil) {
        self.key = key
        super.init(parameterName: parameterName, objectClassName: "", tagName: "size", needAddId: false)
    }
    
    override func handledClassNames() -> [String] {
        return ["T.\(parameterName)-"]
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let dataParameter = parameter as? XibDataParameter else {
            return .empty(false)
        }
        
        do {
            
            let stream = DataStream(with: dataParameter.value as NSData)
            stream.position = 1
            let width = try stream.readDouble()
            let heigth = try stream.readDouble()
            
            
            let tag = Tag(name: tagName)
            tag.addParameter(name: "key", value: key ?? parameter.name.xmlParameterName())
            
            tag.addParameter(name: "width", value: "\(width)")
            tag.addParameter(name: "height", value: "\(heigth)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
