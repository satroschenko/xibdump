//
//  XibConstants.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

enum DataStreamError: Error {
    case streamEnded
    case streamTooShort
    case wrongXibHeader
    case wrongMajorVersion
    case wrongMinorVersion
    case wrongFileFormat
}

enum XibArchiveHeaderValues: Int {
    case majorVersion = 1
    case minorVersion = 9
};



extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
