//
//  ShadowOffsetDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/4/19.
//

import Cocoa

class SizeTagDecoder: DefaultTagDecoder {
    
    static func allDecoders() -> [TagDecoderProtocol] {
        
        return [
            SizeTagDecoder(parameterName: "UITitleShadowOffset", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: nil),
            SizeTagDecoder(parameterName: "UIShadowOffset", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: nil),
            SizeTagDecoder(parameterName: "UISegmentContentOffset", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: "contentOffset"),
            SizeTagDecoder(parameterName: "UISegmentContentOffset", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: "contentOffset"),
            SizeTagDecoder(parameterName: "UIItemSize", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: "itemSize"),
            SizeTagDecoder(parameterName: "UIHeaderReferenceSize", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: "headerReferenceSize"),
            SizeTagDecoder(parameterName: "UIFooterReferenceSize", objectClassName: "", tagName: "size", needAddId: false, tagMapper: nil, keyParameter: "footerReferenceSize")
        ]
    }
    
    let firstName: String
    let secondName: String
    
    init(parameterName: String,
         objectClassName: String,
         tagName: String,
         needAddId: Bool = true,
         tagMapper: [String: String]? = nil,
         keyParameter: String? = nil,
         firstName: String = "width",
         secondName: String = "height") {
        
        self.firstName = firstName
        self.secondName = secondName
        
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName, needAddId: needAddId, tagMapper: tagMapper, keyParameter: keyParameter)
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
            tag.addParameter(name: "key", value: keyParameter ?? parameter.name.systemParameterName())
            
            tag.addParameter(name: firstName, value: "\(width)")
            tag.addParameter(name: secondName, value: "\(heigth)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
