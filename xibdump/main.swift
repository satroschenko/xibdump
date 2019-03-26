//
//  main.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation

func printUsage() {

    let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent

    print("NAME\n")
    print("\t\t\(executableName) to print structure of xib files\n\n")

    print("SYNOPSIS\n")
    print("\t\t\(executableName) 'path to file'\n\n")

    print("DESCRIPTION\n")
    print("\t\t\(executableName) is a command line tool to inspect the structure of compiled, .nib or .storyboardc files.\n\n")

    print("\n")
}

let argCount = CommandLine.argc
if argCount < 2 {
    printUsage()
    exit(0)
}

let fileName = CommandLine.arguments[1]
let url  = URL(fileURLWithPath: fileName)

do {

    let parser = XibFileParser()
    let xibFile = try parser.parse(url: url)

    let logger = XibLogger(xibFile: xibFile)
    logger.printDump()

} catch {
    print("Error: \(error)")
}
