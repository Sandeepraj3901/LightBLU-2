//
//  SampleDB.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 3/2/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import AWSDynamoDB
import AWSAuthCore
import AWSCore
import AWSCognito

 class SampleDB: AWSDynamoDBObjectModel, AWSDynamoDBModeling {
    
    var id: String?
    //var id2: String?
    static func dynamoDBTableName() -> String {
        
        return "Sample1"
        
    }
    
    static func hashKeyAttribute() -> String {
     
        return "userid"
    }
    

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
