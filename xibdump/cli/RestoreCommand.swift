//
//  DecodeCommand.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa
import SwiftCLI

class RestoreCommand: Command {
    
    let name: String = "restore"
    let shortDescription: String = "Restore structure of compiled .nib or .storyboardc files"
    
    let fileName = Parameter(completion: .filename)
    let outputDir = Parameter(completion: .filename)
    
    func execute() throws {
        
        let outputDirUrl = URL(fileURLWithPath: outputDir.value)
        try FileManager.default.createDirectory(at: outputDirUrl, withIntermediateDirectories: true, attributes: nil)
        
        let fileNameUrl = URL(fileURLWithPath: fileName.value)
        
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: fileNameUrl.path, isDirectory: &isDir)
        guard exist else {
            throw CLI.Error(message: "Input file doesn't exist")
        }
        
        if isDir.boolValue {
            
        } else {
            try processSingleFile(fileUrl: fileNameUrl, outputDirUrl: outputDirUrl)
        }
    }
    
    
    fileprivate func processSingleFile(fileUrl: URL, outputDirUrl: URL) throws {

        let parser = XibFileParser()
        let xibFile = try parser.parse(url: URL(fileURLWithPath: fileName.value))
        
//        let logger = XibLogger(xibFile: xibFile)
//        logger.printDump()

        let decoder = XibDecoder(xibFile: xibFile)
        decoder.decode()
        
        let outputFileUrl = outputDirUrl.appendingPathComponent(fileUrl.lastPathComponent).appendingPathExtension("xib")
        try decoder.save(to: outputFileUrl)
    }
    
    
    fileprivate func processDir(dirUrl: URL, outputDirUrl: URL) throws {
        
    }
}
