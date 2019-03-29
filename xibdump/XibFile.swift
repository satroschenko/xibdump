//
//  XibFile.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/25/19.
//

import Cocoa

class XibFile: NSObject {

    var majorVersion: Int = 0
    var minorVersion: Int = 0
    var objectCount: Int = 0
    var objectFileOffset: Int = 0
    var keyCount: Int = 0
    var keyFileOffset: Int = 0
    var parametersCount: Int = 0
    var parametersFileOffset: Int = 0
    var classNameCount: Int = 0
    var classNameFileOffset: Int = 0

    var xibKeys = [String]()
    var xibClasses = [XibClass]()
    var xibParameters = [XibParameterProtocol]()
    var xibObjects = [XibObject]()

    override var description: String {
        return """
        XibFile. [
        MajorVersion: \(self.majorVersion).
        MinorVersion: \(self.minorVersion).
        ObjectCount: \(objectCount).
        ObjectFileOffset: \(objectFileOffset).
        KeyCount: \(keyCount).
        KeyFileOffset: \(keyFileOffset).
        ParametersCount: \(parametersCount).
        ParametersFileOffset: \(parametersFileOffset).
        ClassNameCount: \(classNameCount).
        ClassNameFileOffset: \(classNameFileOffset).
        ]
        """
    }

    func clean() {

        for obj in xibObjects {
            obj.isSerialized = false
        }
    }
}
