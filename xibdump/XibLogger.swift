//
//  XibLogger.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class ParserContext: NSObject {

    var debugPrint: Bool = false
    let xibFile: XibFile
    init(xibFile: XibFile) {
        self.xibFile = xibFile
        super.init()
    }
}

class XibLogger: NSObject {

    let context: ParserContext

    init(xibFile: XibFile) {
        self.context = ParserContext(xibFile: xibFile)
        super.init()
    }

    final func printDump() {

        self.context.xibFile.clean()
        self.context.debugPrint = true
        if let firstObject = self.context.xibFile.xibObjects.first {
            self.parse(object: firstObject, parameterName: "", context: self.context)
        }
    }

    fileprivate func parse(object: XibObject, parameterName: String, context: ParserContext, tabCount: Int = 0) {

        if context.debugPrint {
            print("\(String(repeating: "\t", count: tabCount))|-\(object.xibClass.name)(\(object.objectId))")
        }

        if object.isSerialized {
            return
        }
        object.isSerialized = true

        let start = object.xibValueIndex
        let end = object.xibValueIndex + object.valueCount

        if context.debugPrint {
            print("\(String(repeating: "\t", count: tabCount+1))|")
        }

        for index in start ..< end {

            if let parameter = context.xibFile.xibParameters[safe:index] {

                if context.debugPrint {
                    print("\(String(repeating: "\t", count: tabCount+1))|-\(parameter.toString())")
                }
                self.parse(parameter: parameter, context: context, tabCount: tabCount+1)
            }
        }

        return
    }

    fileprivate func parse(parameter: XibParameterProtocol, context: ParserContext, tabCount: Int = 0) {

        if let xibObject = parameter.object(with: context) {
            self.parse(object: xibObject, parameterName: parameter.name, context: context, tabCount: tabCount)
        }
    }
}
