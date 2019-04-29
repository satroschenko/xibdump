//
//  FileProtocol.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa
import SwiftCLI


enum XibFileFormat {
    case unknown
    case nib
    case storyboard
}


class FileFactory: NSObject {
    
    static func file(url: URL) throws -> FileProtocol {
        
        let exist = FileManager.default.fileExists(atPath: url.path, isDirectory: nil)
        guard exist else {
            throw CLI.Error(message: "Input file doesn't exist")
        }
        
        if case .storyboard  = format(url: url) {
            return StoryboardFile(filePath: url)
        }
        return NibFile(filePath: url)
    }
    
    static func format(url: URL) -> XibFileFormat {
        
        var fileFormat: XibFileFormat = .unknown
        if url.pathExtension == "nib" {
            fileFormat = .nib
        } else if url.pathExtension == "storyboardc" {
            fileFormat = .storyboard
        }
        
        return fileFormat
    }
}

protocol FileProtocol {
    
    func path() -> URL    
    func isFile() -> Bool
    func format() -> XibFileFormat
    func files() -> [FileProtocol]
    func process( function: (FileProtocol) throws -> Void ) throws
}

extension FileProtocol {
    
    func process(function: (FileProtocol) throws -> Void) throws {
        
        if isFile() {
            try function(self)
        } else {
            
            for oneFile in files() {
                try oneFile.process(function: { (fileProtocol) in
                    try function(fileProtocol)
                })
            }
        }
    }
    
    func isFile() -> Bool {
        var isDir: ObjCBool = false
        let exist = FileManager.default.fileExists(atPath: path().path, isDirectory: &isDir)
        
        return !isDir.boolValue && exist
    }
    
    func format() -> XibFileFormat {
        return FileFactory.format(url: path())
    }

    func files() -> [FileProtocol] {
        
        if isFile() {
            return []
        }
        
        var result: [FileProtocol] = [FileProtocol]()
        
        if case .storyboard = format() {
            if let child = try? FileManager.default.contentsOfDirectory(atPath: path().path) {
                
                for children in child where children.hasSuffix(".nib") {
                    let fullPath = path().appendingPathComponent(children)
                    if let file = try? FileFactory.file(url: fullPath) {
                        result.append(file)
                    }
                }
            }
        } else {
            
            var finalFile = path().appendingPathComponent("objects-11.0+.nib")
            let exist = FileManager.default.fileExists(atPath: finalFile.path, isDirectory: nil)
            if !exist {
                finalFile = path().appendingPathComponent("runtime.nib")
            }
            if let file = try? FileFactory.file(url: finalFile) {
                result.append(file)
            }
        }

        return result
    }
}
