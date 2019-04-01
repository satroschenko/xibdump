//
//  UIBoundsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIBoundsDecoder: NSObject, CustomTagDecoderProtocol {

    
    func handledClassName() -> String {
        return "T.UIBounds-"
    }
    
    func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
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
            
            let tag = Tag(name: "rect")
            tag.addParameter(name: "x", value: "\(xCoord)")
            tag.addParameter(name: "y", value: "\(yCoord)")
            tag.addParameter(name: "width", value: "\(width)")
            tag.addParameter(name: "height", value: "\(heigth)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
