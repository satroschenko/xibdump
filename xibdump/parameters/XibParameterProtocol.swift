//
//  XibParameter.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

enum XibParameterType: Int {
    case int8 = 0
    case int16 = 1
    case int32 = 2
    case int64 = 3
    case aFalse = 4
    case aTrue = 5
    case float = 6
    case double = 7
    case data = 8
    case null = 9
    case object = 10
}


protocol XibParameterProtocol: NSObjectProtocol {
    var name: String {get}
    var type: XibParameterType {get}
    
    func description() -> String
    func stringValue() -> String
}
