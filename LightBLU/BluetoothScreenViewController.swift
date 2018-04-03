//
//  BluetoothScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import CoreBluetooth
let NAME = "CSR1010"
let B_UUID =
    CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
let BSERVICE_UUID =
    CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
var cell = [String]()

class BluetoothScreenViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITableViewDelegate, UITableViewDataSource{
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        return
    }
    
   
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(cell.count)
        return cell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        
        cells.textLabel?.text = cell[indexPath.row]
        print(cells)
        return cells
    }
    
    /*func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is ON.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            
            print("Bluetooth not available.")
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is Off.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
*/
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lb5")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   /* func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        print("hello:\(peripheral)")
     /*   if device?.contains(NAME) == true{
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        }*/
    }*/
    
   /* func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("hello:\(String(describing: peripheral.name))")
        cell.append(String(describing: peripheral.name))
        
        let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
            as? NSString
        if device?.contains("CSR1010") == true{
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
        
    }
    }
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
        peripheral.delegate = self
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            peripheral.discoverCharacteristics(nil, for: thisService)
            
            /* if service.uuid == BSERVICE_UUID {
             peripheral.discoverCharacteristics(nil, for: thisService)
             }*/
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print(thisCharacteristic.uuid)
            if thisCharacteristic.uuid == B_UUID {
                
                self.peripheral.setNotifyValue(true, for: thisCharacteristic)
            }
        }
    }
    
   
    
    
     func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        var _:UInt32 = 0;
        if characteristic.uuid == B_UUID {
            print(characteristic.value!)
            //characteristic.value!.getBytes(&count, length: sizeof(UInt32))
            //labelCount.text = NSString(format: "%llu", count) as String
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    */
    
    
}
