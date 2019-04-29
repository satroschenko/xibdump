//
//  TagUtils.swift
//  xibdump
//
//  Created by Sergey Atroschenko on 4/29/19.
//

import Cocoa

extension Tag {
    
    func addNoYesParameter(object: XibObject, name: String, context: ParserContext, tagName: String) {
        
        let noYesTypes: [String] = ["", "no", "yes"]
        
        if let value = object.findIntParameter(name: name, context: context) {
            
            let name = noYesTypes[safe: value] ?? ""
            if !name.isEmpty {
                addParameter(name: tagName, value: name)
            }
        }
    }
    
    func addBoolParameter(object: XibObject, name: String, context: ParserContext, tagName: String) {
        
        if let isTag = object.findBoolParameter(name: name, context: context) {
            addParameter(name: tagName, value: isTag ? "YES" : "NO")
        }
    }
    
    func extractDataDetectorType(value: Int) {
        
        let optionSet = DataDetectorTypesDecoder.DataDetectorTypeOptionSet(rawValue: value)
        
        if optionSet.contains(.phoneNumber) {
            addParameter(name: "phoneNumber", value: "YES")
        }
        if optionSet.contains(.link) {
            addParameter(name: "link", value: "YES")
        }
        if optionSet.contains(.address) {
            addParameter(name: "address", value: "YES")
        }
        if optionSet.contains(.calendarEvent) {
            addParameter(name: "calendarEvent", value: "YES")
        }
        if optionSet.contains(.shipmentTrackingNumber) {
            addParameter(name: "shipmentTrackingNumber", value: "YES")
        }
        if optionSet.contains(.flightNumber) {
            addParameter(name: "flightNumber", value: "YES")
        }
        if optionSet.contains(.lookupSuggestion) {
            addParameter(name: "lookupSuggestion", value: "YES")
        }
    }
}
