//
//  Utils.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa

class Utils: NSObject {

    
    static func decoderKey(parameterName: String, className: String, isTopLevel: Bool) -> String {
        
        let prefix = isTopLevel ? "T." : "A."
        let suffix = "\(parameterName)-\(className)"
        
        return "\(prefix)\(suffix)"
    }
}
