//
//  NibFile.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa

class NibFile: NSObject, FileProtocol {
    
    let filePath: URL
    
    init(filePath: URL) {
        self.filePath = filePath
        super.init()
    }
    
    func path() -> URL {
        return filePath
    }
}
