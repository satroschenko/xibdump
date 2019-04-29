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
        
        let file = try FileFactory.file(url: URL(fileURLWithPath: fileName.value))
        try file.process { (fileProtocol: FileProtocol) in
            print("File: \(fileProtocol.path())")
            let xibFile = try parser.parse(url: fileProtocol.path())
            xibFile.logToConsole()
        }
    }
}
