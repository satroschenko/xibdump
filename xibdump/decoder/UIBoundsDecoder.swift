//
//  UIBoundsDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class UIBoundsDecoder: NSObject, CustomTagDecoderProtocol {

    
    func handledClassNames() -> [String] {
        return ["T.UIBounds-"]
    }
    
    func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let dataParameter = parameter as? XibDataParameter else {
            return .empty(false)
        }
        
        
        
        do {
            
            let stream = DataStream(with: dataParameter.value as NSData)
            stream.position = 1
            var xCoord = try stream.readDouble()
            var yCoord = try stream.readDouble()
            let width = try stream.readDouble()
            let heigth = try stream.readDouble()
            
            
            if let centerData = parentObject.findDataParameter(name: "UICenter", context: context) {
                let centerStream = DataStream(with: centerData as NSData)
                centerStream.position = 1
                
                let centerX = try centerStream.readDouble()
                let centerY = try centerStream.readDouble()
                
                xCoord = centerX - width / 2.0
                yCoord = centerY - heigth / 2.0
            }
            
            let tag = Tag(name: "rect")
            tag.addParameter(name: "key", value: "frame")
            
            tag.addParameter(name: "x", value: "\(xCoord)")
            tag.addParameter(name: "y", value: "\(yCoord)")
            tag.addParameter(name: "width", value: "\(width)")
            tag.addParameter(name: "height", value: "\(heigth)")
            
            return .tag(tag, false)
            
        } catch {}
        return .empty(false)
    }
}
