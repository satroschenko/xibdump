//
//  MTKViewDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/9/19.
//

import Cocoa

class MTKViewDecoder: DefaultTagDecoder {

    init() {
        super.init(parameterName: "UINibEncoderEmptyKey", objectClassName: "MTKView", tagName: "mtkView")
    }
    
    override func parse(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        let result = super.parse(parentObject: parentObject, parameter: parameter, context: context)
        if case let .tag(tag, _)  = result {
            
            guard let object = parameter.object(with: context) else {
                return result
            }
            
            fillPixelFormat(object: object, context: context, tag: tag)
            fillStencilPizelFormat(object: object, context: context, tag: tag)
        }
        
        return result
    }
    
    
    fileprivate func fillPixelFormat(object: XibObject, context: ParserContext, tag: Tag) {
        if let colorPixelFormat = object.findIntParameter(name: "MTKViewColorPixelFormatCoderKey", context: context) {
            
            if colorPixelFormat == 80 {
                tag.addParameter(name: "colorPixelFormat", value: "BGRA8Unorm")
            } else if colorPixelFormat == 81 {
                tag.addParameter(name: "colorPixelFormat", value: "BGRA8Unorm_sRGB")
            } else if colorPixelFormat == 552 {
                tag.addParameter(name: "colorPixelFormat", value: "BGRA10_XR")
            } else if colorPixelFormat == 553 {
                tag.addParameter(name: "colorPixelFormat", value: "BGRA10_XR_sRGB")
            } else if colorPixelFormat == 554 {
                tag.addParameter(name: "colorPixelFormat", value: "BGR10_XR")
            } else if colorPixelFormat == 555 {
                tag.addParameter(name: "colorPixelFormat", value: "BGR10_XR_sRGB")
            }
        }
    }
    
    
    fileprivate func fillStencilPizelFormat(object: XibObject, context: ParserContext, tag: Tag) {
        if let depthStencilPixelFormat = object.findIntParameter(name: "MTKViewDepthStencilPixelFormatCoderKey", context: context) {
            
            if depthStencilPixelFormat == 0 {
                tag.addParameter(name: "depthStencilPixelFormat", value: "Invalid")
            } else if depthStencilPixelFormat == 252 {
                tag.addParameter(name: "depthStencilPixelFormat", value: "Depth32Float")
            } else if depthStencilPixelFormat == 253 {
                tag.addParameter(name: "depthStencilPixelFormat", value: "Stencil8")
            } else if depthStencilPixelFormat == 260 {
                tag.addParameter(name: "depthStencilPixelFormat", value: "Depth32Float_Stencil8")
            }
        }
    }
}
