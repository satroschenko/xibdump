//
//  UIRectDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/2/19.
//

import Cocoa

class UIRectDecoder: NewTagDecoder {
    
    static func allDecoders() -> [CustomTagDecoderProtocol] {
        
        return [
            UIRectDecoder(parameterName: "UIContentStretch",
                          objectClassName: "",
                          tagName: "rect",
                          needAddId: false,
                          mapper: nil,
                          keyParameter: nil),
            
            UIRectDecoder(parameterName: "UISeparatorInset",
                          objectClassName: "",
                          tagName: "inset",
                          needAddId: false,
                          mapper: nil,
                          keyParameter: "separatorInset",
                          xParam: "minY",
                          yParam: "minX",
                          widthParam: "maxY",
                          heightParam: "maxX"),
            
            UIRectDecoder(parameterName: "UIScrollIndicatorInsets",
                          objectClassName: "",
                          tagName: "inset",
                          needAddId: false,
                          mapper: nil,
                          keyParameter: "scrollIndicatorInsets",
                          xParam: "minY",
                          yParam: "minX",
                          widthParam: "maxY",
                          heightParam: "maxX"),
            
            UIRectDecoder(parameterName: "UISectionInset",
                          objectClassName: "",
                          tagName: "inset",
                          needAddId: false,
                          mapper: nil,
                          keyParameter: "sectionInset",
                          xParam: "minY",
                          yParam: "minX",
                          widthParam: "maxY",
                          heightParam: "maxX")
        ]
    }
    
    
    let xParam: String
    let yParam: String
    let widthParam: String
    let heightParam: String
    
    init(parameterName: String,
         objectClassName: String,
         tagName: String,
         needAddId: Bool = true,
         mapper: [String: String]? = nil,
         keyParameter: String? = nil,
         xParam: String = "x",
         yParam: String = "y",
         widthParam: String = "width",
         heightParam: String = "height") {
        
        self.xParam = xParam
        self.yParam = yParam
        self.widthParam = widthParam
        self.heightParam = heightParam
        super.init(parameterName: parameterName, objectClassName: objectClassName, tagName: tagName, needAddId: needAddId, mapper: mapper, keyParameter: keyParameter)
    }
    
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let dataParameter = parameter as? XibDataParameter else {
            return .empty(false)
        }
        
        do {
            
            let stream = DataStream(with: dataParameter.value as NSData)
            stream.position = 1
            let xCoord = try stream.readDouble()
            let yCoord = try stream.readDouble()
            let width = try stream.readDouble()
            let heigth = try stream.readDouble()
            
            
            let tag = Tag(name: tagName)
            tag.addParameter(name: "key", value: keyParameter ?? parameter.name.xmlParameterName())
            
            tag.addParameter(name: xParam, value: "\(xCoord)")
            tag.addParameter(name: yParam, value: "\(yCoord)")
            tag.addParameter(name: widthParam, value: "\(width)")
            tag.addParameter(name: heightParam, value: "\(heigth)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
