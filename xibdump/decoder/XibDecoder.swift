//
//  XibDecoder.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 3/29/19.
//

import Cocoa
import AEXML
import SwiftCLI

class XibDecoder: NSObject {

    let parentTag: Tag = XibParentTag()
    let parsers = CustomDecodersHolder()
    
    init(xibFile: XibFile) {
        super.init()
    }
    
    func decode() {
        
//        scanner.delegate = self
//        scanner.start()
    }
    
    func save(to url: URL) throws {
        
        let soapRequest = AEXMLDocument()
        soapRequest.addChild(parentTag.getNode())
        
        guard let data = soapRequest.xml.data(using: .utf8) else {
            throw CLI.Error(message: "Error data serialization.")
        }
        
        try data.write(to: url)        
    }
}



//extension XibDecoder: XibScannerProtocol {
//
//    func objectStarted(object: XibObject, parameterName: String, context: ParserContext, tabCount: Int) -> Bool {
//        return true
//    }
//
//    func objectFinished(object: XibObject, parameterName: String, context: ParserContext, tabCount: Int) -> Bool {
//        return true
//    }
//
//    func parameterStarted(parentObject: XibObject, parameter: XibParameterProtocol, context: ParserContext, tabCount: Int) -> Bool {
//
//        let objectName = parameter.object(with: context)?.xibClass.name ?? ""
////        var skipChild = false
////        var customParserFound = false
//
//        if let customSerializer = parsers.parser(by: objectName, parameterName: parameter.name) {
//
////            customParserFound = true
//            let parsingResult = customSerializer.parse(parentObject: parentObject, parameter: parameter, context: context)
//            switch parsingResult {
//
//            case .childTags(let tags):
//                parentTag.add(tags: tags)
//
//            case .childParams(let params):
//                parentTag.add(parameters: params)
//
//            case .endNewTag(let tag):
//                parentTag.add(tag: tag)
////                skipChild = true
////                parentTag = currentTag
//
//            case .beginNewTag(let newTag):
//                parentTag.add(tag: newTag)
////                parentTag = newTag
//
//            default:
//                break
//            }
//
//        }
//
//
//        return true
//    }
//}
//
//
extension Tag {

    func getNode() -> AEXMLElement {

        let node = AEXMLElement(name: name)
        for parameter in allParameters() {
            node.attributes[parameter.name] = parameter.value
        }

        for child in allChildren() {
            node.addChild(child.getNode())
        }

        return node
    }
}
