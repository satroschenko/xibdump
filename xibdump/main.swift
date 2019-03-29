//
//  main.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//  Copyright © 2019. All rights reserved.
//

import Cocoa
import SwiftCLI

setlinebuf(stdout)

let myCli = CLI(name: "xibdump", version: Version.current.value, description: Version.info)
myCli.commands = [PrintCommand()]

myCli.goAndExit()
