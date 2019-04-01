//
//  TagParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class TagParameter: NSObject {

    let name: String
    let value: String
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
        super.init()
    }
    
    override var description: String {
        return "\(self.name) - \(self.value)"
    }
}
