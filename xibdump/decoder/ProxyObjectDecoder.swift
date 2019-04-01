//
//  ProxyObjectDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/1/19.
//

import Cocoa

class ProxyObjectDecoder: NewTagDecoder {

    init() {
        super.init(parameterName: "UINibEncoderEmptyKey", objectClassName: "UIProxyObject", tagName: "")
    }
    
    override func parse(parameter: XibParameterProtocol, context: ParserContext) -> TagDecoderResult {
        
        guard let object = parameter.object(with: context) else {
            return .empty(false)
        }
        
        guard object.valueCount > 0 else {
            return .empty(false)
        }
        
        return .empty(true)
    }
}
