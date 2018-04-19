//
//  Scheduler.swift
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

@objcMembers class Scheduler: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
     @objc var _userId: String?
     @objc var _scheduletime: String?
     @objc var _intVal: String?
     @objc var _switchval: String?
     @objc var _colorValue: String?
     @objc var _savedTime: String?
    
    class func dynamoDBTableName() -> String {

        return "lightblu-mobilehub-144292023-Scheduler"
    }
    
    class func hashKeyAttribute() -> String {

        return "_userId"
    }
    
    class func rangeKeyAttribute() -> String {

        return "_scheduletime"
    }
    
    override class func jsonKeyPathsByPropertyKey() -> [AnyHashable: Any] {
        return [
               "_userId" : "userId",
               "_scheduletime" : "Scheduletime",
               "_intVal" : "IntVal",
               "_switchval" : "Switchval",
               "_colorValue" : "colorValue",
               "_savedTime" : "savedTime",
        ]
    }
}