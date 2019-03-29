//
//  Xib_UIBoundsParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa

class XibUIBoundsParameter: XibDataParameter {

    let xCoord: Double
    let yCoord: Double
    let width: Double
    let height: Double
    
    required init(name: String, value: Data) {
        
        let stream = DataStream(with: value as NSData)
        stream.position = 1
        xCoord = (try? stream.readDouble()) ?? 0
        yCoord = (try? stream.readDouble()) ?? 0
        width = (try? stream.readDouble()) ?? 0
        height = (try? stream.readDouble()) ?? 0
        
        super.init(name: name, value: value)
    }
    
    override func toString() -> String {
        return "(data)\(name): {\(xCoord), \(yCoord), \(width), \(height)}"
    }
}
