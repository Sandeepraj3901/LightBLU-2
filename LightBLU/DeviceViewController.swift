//
//  DeviceViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 3/6/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit

class DeviceViewController: UIViewController {

    @IBOutlet weak var DeviceLabel: UILabel!
    var selectedName: String = " "
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let b1: BluetoothTableViewController = BluetoothTableViewController()
       
        DeviceLabel.text = selectedName

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
