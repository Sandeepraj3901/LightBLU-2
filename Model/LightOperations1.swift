//
//  LightOperations1.swift
//  MySampleApp
//
//
// Copyright 2018 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

@objcMembers class LightOperations1: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
     @objc var _opId: NSNumber?
     @objc var _phonedeviceName: String?
     @objc var _colorId: String?
     @objc var _deviceStatus: String?
    @objc var _intensityVal: String?
    @objc var _lastUpdated: String?
    @objc var _lightdeviceName: String?
    
    class func dynamoDBTableName() -> String {

        return "lightblu-mobilehub-144292023-LightOperations1"
    }
    
    class func hashKeyAttribute() -> String {

        return "_opId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_phonedeviceName"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_opId" : "opId",
               "_phonedeviceName" : "phonedeviceName",
               "_colorId" : "colorId",
               "_deviceStatus" : "deviceStatus",
               "_intensityVal" : "intensityVal",
               "_lastUpdated" : "lastUpdated",
               "_lightdeviceName" : "lightdeviceName",
        ]
    }
}
