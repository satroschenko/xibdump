//
//  XibID.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//  Copyright © 2019. All rights reserved.
//

import Cocoa

class XibID: NSObject {

    private static let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    
    static func generate() -> String {
        
        return "\(self.randomString(length: 3))-\(self.randomString(length: 2))-\(self.randomString(length: 3))"
    }
    
    
    private static func randomString(length: Int) -> String {
        
        var charactersArray = XibID.charSet.map { String($0) }
        var string:String = ""
        for _ in (1...length) {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
}
