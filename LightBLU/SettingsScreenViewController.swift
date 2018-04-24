//
//  SettingsScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit

class SettingsScreenViewController: UIViewController {
 let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var Dname: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if( appDelegate.dstatus == "Connected")
        {
            self.Dname.text = appDelegate.dname1
        }
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lb5")!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewDidLoad()
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
