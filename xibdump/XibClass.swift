//
//  XibClass.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class XibClass: NSObject {

    let name: String
    let extraValues: [Int]

    init(name: String, extraValues: [Int]) {
        self.name = name
        self.extraValues = extraValues
        super.init()
    }

    override var description: String {
        return "XibClass/ [Name: \(self.name). ExtraValues: \(self.extraValues).]"
    }
}
