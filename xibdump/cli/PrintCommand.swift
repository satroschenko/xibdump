//
//  XibCommand.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/27/19.
//

import Cocoa
import SwiftCLI

class PrintCommand: Command {

    let name: String = "print"
    let shortDescription: String = "Print structure of compiled .nib file"
    
    let fileName = Parameter(completion: .filename)
    
    func execute() throws {
        
        let parser = XibFileParser()
        let xibFile = try parser.parse(url: URL(fileURLWithPath: fileName.value))
        
        let logger = XibLogger(xibFile: xibFile)
        logger.printDump()
    }
}
