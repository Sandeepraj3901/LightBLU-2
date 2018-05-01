//
//  BluetoothTableViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 3/2/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import CoreBluetooth
import AWSDynamoDB
import AWSAuthCore
import AWSCore
import AWSCognito


class BluetoothTableViewController: UITableViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var password = "xxx"
    var match = 0
    @IBOutlet weak var sublabel: UILabel!
    var name: String = " "
    var NAME: String = "LED BLU"
    var status = "'"
    let B_UUID =
        CBUUID(string: "0000AB07-D102-11E1-9B23-00025B00A5A5")
    //0000AB07-D102-11E1-9B23-00025B00A5A5--0x1802
   // let Device = CBUUID(string: "0x1800")
    let Devicec = CBUUID(string: "0x2A00")
    let BSERVICE_UUID =
        CBUUID(string: "0000AB05-D102-11E1-9B23-00025B00A5A5")
    var perip = Array<CBPeripheral>()
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(perip.count)
        return perip.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cells = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as UITableViewCell
        let peripheral1 = perip[indexPath.row]
        
               cells.textLabel?.text = peripheral1.name
                if(peripheral1.name == self.NAME && appDelegate.password == "Sandy")
                {
                    cells.detailTextLabel?.text = "Connected"
                    appDelegate.dname1 = peripheral1.name!
                    
                }
                else
                {
                    cells.detailTextLabel?.text = "Not Connected"
                }
        
        
        //print(cells)
        return cells
    }
    
   
    
    var manager:CBCentralManager!
    var peripherals:CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addSubview(self.refreshControl1)
        self.password = appDelegate.password
     
        manager = CBCentralManager(delegate: self, queue: nil)
            
        
//        else
//        {
//            let alertController = UIAlertController(title: "Alert", message:
//                "Please check the password.", preferredStyle: UIAlertControllerStyle.alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
//
//            self.present(alertController, animated: true, completion: nil)
//            manager = CBCentralManager(delegate: self, queue: nil)
//        }
        // Do any additional setup after loading the view.
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tableView.reloadData()
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
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            
        } else {
            
            print("Bluetooth not available.")
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is Off.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
       
        /*if(cell.contains(String(describing: peripheral.identifier.uuid)) == false && cell.count < 15)
        {
        cell.append(String(describing: peripheral.identifier.uuidString))
        
        print("welcome:\(cell)")
        print(cell.count)
        }*/
        //print(peripherals)
        print("Discovered: \(String(describing: peripheral)) at \(RSSI)")
        print("AdvertisementData:\(advertisementData)")
        if (peripherals != peripheral && peripheral.name != nil)
        {
            peripherals = peripheral
            print(peripherals)
         
            perip.append(peripherals)
        }
       self.tableView.reloadData()
       /* let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey )
            as? NSString
        print(String(describing: device))
        //CBAdvertisementDataLocalNameKey
        
     */
       if(peripheral.name != nil )
       {
        name = peripheral.name!
        if (peripheral.name == self.NAME)
        {
           //self.sublabel.text = "Connected"
            let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
                as? NSString
            print("hello:\(peripheral) and \(String(describing: device))")
            if device?.isEqual(to: NAME) == true{
            //self.manager.stopScan()
            print("Found:\(name), and \(NAME)")
            //manager.connect(peripherals, options: nil)
            print("23454556666")
                self.peripherals = peripheral
                self.peripherals.delegate = self
                //manager.connect(peripherals, options: nil)
                if (perip.count > 10)                                                                                                                                                                                                                                                                                                                   
                {self.manager.stopScan()}
             
                //print(peripherals)
               
                self.viewDidAppear(true)
            }
            self.peripherals = peripheral
            self.peripherals.delegate = self
           
        }
        else
        {
            print("no device found")
            //self.manager.stopScan()
            
            
        }
       }
       else
        {
            print("no peripheral name")
            name = " No Device"
        }
}
      
        
    
    
    
//    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
//        print("CONNECTED")
//        peripheral.discoverServices(nil)
//        peripheral.delegate = self
//
//
//
//
//    }
    // Called when it succeeded
//    func centralManager(_ central: CBCentralManager,
//                                 didConnect peripherals: CBPeripheral)
//    {
//        print(peripherals)
//        print("connected!")
//        status = "Connected"
//        appDelegate.dstatus = status
//        peripherals.delegate = self
//        peripherals.discoverServices(nil)
//
//
//    }
//    // Called when it failed
//    func centralManager(_ central: CBCentralManager,
//                        didFailToConnect peripheral: CBPeripheral,
//                        error: Error?)
//    {
//        print("failed…")
//        status = " Not Connected"
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//        for service in peripheral.services! {
//            let thisService = service as CBService
//            //peripheral.discoverCharacteristics(nil, for: thisService)
//            print("in service:\(thisService)")
//            if service.uuid == BSERVICE_UUID{
//            //if service.uuid == Device{
//             peripheral.discoverCharacteristics(nil, for: thisService)
//             }
//        }
//    }
//
//    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//        print("in characteristics")
//        for characteristic in service.characteristics! {
//            let thisCharacteristic = characteristic as CBCharacteristic
//            print(thisCharacteristic.uuid)
//            if thisCharacteristic.uuid == B_UUID{
//                //if thisCharacteristic.uuid == Devicec{
//                //let ch = thisCharacteristic
//                print("found matching characteristic")
//                //peripherals.setNotifyValue(true, for: thisCharacteristic)
//                 //self.peripherals.delegate = self
//                if thisCharacteristic.properties.contains(.read) {
//                    print("\(thisCharacteristic.uuid): properties contains .read")
//                }
//                if thisCharacteristic.properties.contains(.notify) {
//                    print("\(thisCharacteristic.uuid): properties contains .notify")
//                }
//                if thisCharacteristic.properties.contains(.write) {
//                    print("\(thisCharacteristic.uuid): properties contains .write")
//                }
//
//                //peripheral.readValue(for: thisCharacteristic)
//                peripheral.setNotifyValue(true, for: thisCharacteristic)
//                //thisCharacteristic.value = "tytyty"
//                 print(thisCharacteristic as Any)
//                /// writting data to peripheral device
//                //let d = "FF0000"
//
//
//                var value: [UInt8] = [0xFF,0x47,0x9E]
//                    let data = NSData(bytes: &value, length: value.count) as Data
//                let data1: Data = "A51628".data(using: String.Encoding.utf8)!
//                print(data1)
//               //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
//                    peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
//                 peripheral.readValue(for: thisCharacteristic)
//                }
//            }
//        }
//
//
//
//     func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//
//
//            //print("char value:\(characteristic.value!)")
//            if let error = error {
//                print("Failed… error: \(error)")
//                return
//            }
//
//            print("characteristic uuid: \(characteristic.uuid), value: \(String(describing: characteristic.value))")
//
//
//        }
//
//     func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
//    {
//        if let error = error {
//            print("error: \(String(describing: error))")
//            return
//        }
//        print( characteristic)
//        print("Succeeded!")
//       createid()
//        manager.cancelPeripheralConnection(peripheral)
//    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TabletoDevice") {
           
            let vc = segue.destination as! DeviceViewController
            vc.selectedName = name
        }
    }
//    public func setval(Data1: String, char: CBCharacteristic)
//    {
//        var value: [UInt8] = [0x00, 0xFF, 0x00]
//        let data = NSData(bytes: &value, length: value.count) as Data
//        let data1: Data = Data1.data(using: String.Encoding.utf8)!
//        print(data1)
//        //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
//        peripheral.writeValue(data, for: char, type: CBCharacteristicWriteType.withResponse)
//    }
    public func createid() {
        //        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
        //                                                                identityPoolId:"us-east-2:0c1abe18-9c04-48d9-a362-f4cdb698834f")
        //
        //        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        //
        //        AWSServiceManager.default().defaultServiceConfiguration = configuration
        //
        
        
        
        let dynamoDbObjectMapperBLE = AWSDynamoDBObjectMapper.default()
        
        // Create data object using data models
        let newsItem: Device = Device()
        
        newsItem._deviceId = String(describing: BSERVICE_UUID)
        newsItem._deviceName = name
        newsItem._deviceStatus = status
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        //formatter.timeStyle = DateFormatter.Style.short
        
        newsItem._lastUpdated = formatter.string(from: date)
        //AWSIdentityManager.default().identityId
        
        //Save a new item
        print("value for db:\(String(describing: newsItem._lastUpdated))")
        dynamoDbObjectMapperBLE.save(newsItem, completionHandler: {
            (error: Error?) -> Void in
            // NSLog((error as! NSString) as String)
            if let error = error {
                print("Amazon DynamoDB Save Error: \(error)")
                return
            }
            print("A Device record was saved.")
        })
      
    }
    lazy var refreshControl1: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(BluetoothTableViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
       
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}
