//
//  ScheduleScreenViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import UserNotifications
import CoreBluetooth
extension UIColor {
    var hexString: String {
        let colorRef = cgColor.components
        let r = colorRef?[0] ?? 0
        let g = colorRef?[1] ?? 0
        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
        let a = cgColor.alpha
        
        var color = String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        
        if a < 1 {
            color += String(format: "%02lX", lroundf(Float(a)))
        }
        
        return color
    }
}
extension String {
    var hexa2Byte: [UInt8] {
        let hexa = Array(self)
        return stride(from: 0, to: count, by: 2).flatMap { UInt8(String(hexa[$0..<$0.advanced(by: 2)]), radix: 16) }
    }
}

class ScheduleScreenViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate,UITextFieldDelegate, CBCentralManagerDelegate, CBPeripheralDelegate{

    @IBOutlet weak var colorPicker: SwiftHSVColorPicker!
      var selectedColor: UIColor = UIColor.white
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let colorval = ["Yellow", "Red", "Blue","Green","White","Orange","Black"]
    var pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    var datee = DateComponents()
    var name: String = " "
    var NAME: String = "LED BLU"
    let B_UUID =
        CBUUID(string: "0000AB07-D102-11E1-9B23-00025B00A5A5")
    //0000AB07-D102-11E1-9B23-00025B00A5A5--0x1802
    let Device = CBUUID(string: "0x1800")
    let Devicec = CBUUID(string: "0x2A00")
    let BSERVICE_UUID =
        CBUUID(string: "0000AB05-D102-11E1-9B23-00025B00A5A5")
    var data = Data()
    
    var manager:CBCentralManager!
    var peripherals:CBPeripheral!
     var peripheral:CBPeripheral!
    @IBOutlet weak var schedulertitle: UINavigationBar!
    @IBOutlet weak var alarmtextfield: UITextField!
    @IBOutlet weak var intensitytextfield: UITextField!
    @IBOutlet weak var colortextfield: UITextField!
    @IBOutlet weak var Id: UILabel!
    @IBOutlet weak var Idtextfield: UITextField!
   
    @IBOutlet weak var Switchval: UISwitch!
    
    override func viewDidLoad() {
        self.navigationItem.title = "Scheduler";
        super.viewDidLoad()
         //manager = CBCentralManager(delegate: self, queue: nil)
     self.view.backgroundColor = UIColor(patternImage: UIImage(named: "lb5")!)
        Idtextfield.text = "LED BLU "
//        let backgroundImageView = UIImageView(image: UIImage(named: "lb5"))
//        backgroundImageView.frame = view.frame
//        backgroundImageView.contentMode = .scaleAspectFill
//        view.addSubview(backgroundImageView)
//        view.sendSubview(toBack: backgroundImageView)
        
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler:{ didAllow , error in
            
        })
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg.png")!)
             //pickUp(colortextfield)
        //showDatePicker()
        colorPicker.setViewColor(selectedColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1;
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return colorval.count;
    }
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colorval[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        colortextfield.text = colorval[row]
    }
    
    func pickUp(_ textField : UITextField){
    
    // UIPickerView
        pickerView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
    pickerView.delegate = self
    pickerView.dataSource = self
    pickerView.backgroundColor = UIColor.white
    colortextfield.inputView = pickerView
    
    // ToolBar
    let toolBar = UIToolbar()
    toolBar.barStyle = .default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
    toolBar.sizeToFit()
    
    // Adding Button ToolBar
    let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
    toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true
    textField.inputAccessoryView = toolBar
    
    }
    
    
    @objc  public func doneClick() {
        colortextfield.resignFirstResponder()
    }
     @objc public func cancelClick() {
        colortextfield.resignFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUp(colortextfield)
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .dateAndTime
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        alarmtextfield.inputAccessoryView = toolbar
        alarmtextfield.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        //formatter.timeStyle = DateFormatter.Style.short
        
        alarmtextfield.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Idtextfield.resignFirstResponder()
        return true
    }
    @objc func sendcolor (_ sender: Any)
    {
        print(" Time triggered")
//        let vc : BluetoothTableViewController = BluetoothTableViewController()
//        //vc.peripherals.discoverServices([BSERVICE_UUID])
//        print(vc.peripherals)
//        var value: [UInt8] = [0x00,0x00,0x77]
//        let data = NSData(bytes: &value, length: value.count) as Data
//        vc.peripherals.writeValue(data, for: CBCharacteristic, type: CBCharacteristicWriteType.withResponse)
//
    }
    
    
    @IBAction func SliderActn(_ sender: UISlider) {
        
        print(sender.value)
    }

    @IBAction func savebtn(_ sender: Any) {
        
        if(appDelegate.password == "Sandy" && appDelegate.dstatus == "Connected") {
        if (Switchval.isOn){
        let col = colorPicker.color
        
        var hex = col?.toHexString
        print("Hex:\(String(describing: hex))")
        var hexb = hex?.hexa2Byte
        print("Hexb:\(String(describing: hexb))")
        //data = (hex?.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!
       // print("HexStr Color:\(String(describing: valueString))")
            let strcval = hexaToBytes(hex!)
             print("strcval:\(String(describing: strcval))")
        data = NSData(bytes: &hexb, length: (hexb?.count)!) as Data
         print("HexStr :\(String(describing: data))")
         manager = CBCentralManager(delegate: self, queue: nil)
        }
        else {
            let alertController = UIAlertController(title: "Alert", message:
                "Switch is OFF.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            manager = CBCentralManager(delegate: self, queue: nil)
        }
        }
        else
        {
            let alertController = UIAlertController(title: "Alert", message:
                "Please check Bluetooth device and Password.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
//        let triggerDaily = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute,], from: datePicker.date)
//
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
//
//        let alarmId = UUID().uuidString
//
//        let content = UNMutableNotificationContent()
//        content.title = "Notification"
//        content.body = " Your Request to turn light ON is completed"
//        //content.sound = UNNotificationSound.init(named: "your sound filename.mp3")
//        content.categoryIdentifier = alarmId
//
//        let request = UNNotificationRequest(identifier: "alarmIdentifier", content: content, trigger: trigger)
//
//        //print("alarm identi   : \(alarmIdentifier)")
//
//        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
//        UNUserNotificationCenter.current().add(request) {(error) in
//
//            if let error = error {
//                print("Uh oh! i had an error: \(error)")
//            }
//        }
//        let timer = Timer(fireAt: datePicker.date, interval: 0, target: self, selector: #selector(self.sendcolor), userInfo: nil, repeats: false)
//        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
   }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
            let alertController = UIAlertController(title: "Alert", message:
                "Bluetooth is ON.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            //self.present(alertController, animated: true, completion: nil)
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
            
        }
        
        if(peripheral.name != nil)
        {
            name = peripheral.name!
            if (peripheral.name == "LED BLU")
            {
                //self.sublabel.text = "Connected"
                let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey)
                    as? NSString
                print("hello:\(peripheral) and \(String(describing: device))")
                if device?.contains(NAME) == true{
                    //self.manager.stopScan()
                    print("Found:\(name), and \(NAME)")
                    //manager.connect(peripherals, options: nil)
                    print("23454556666")
                    self.peripherals = peripheral
                    self.peripherals.delegate = self
                    manager.connect(peripherals, options: nil)
                    //print(peripherals)
                    self.manager.stopScan()
                    
                }
                self.peripherals = peripheral
                peripherals.delegate = self
                
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
    func centralManager(_ central: CBCentralManager,
                        didConnect peripherals: CBPeripheral)
    {
        print(peripherals)
        print("connected!")
        peripherals.delegate = self
        peripherals.discoverServices(nil)
        
        
    }
    // Called when it failed
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?)
    {
        print("failed…")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            //peripheral.discoverCharacteristics(nil, for: thisService)
            print("in service:\(thisService)")
            if service.uuid == BSERVICE_UUID{
                //if service.uuid == Device{
                peripheral.discoverCharacteristics(nil, for: thisService)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("in characteristics")
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            print(thisCharacteristic.uuid)
            if thisCharacteristic.uuid == B_UUID{
                //if thisCharacteristic.uuid == Devicec{
                //let ch = thisCharacteristic
                print("found matching characteristic")
                //peripherals.setNotifyValue(true, for: thisCharacteristic)
                //self.peripherals.delegate = self
                if thisCharacteristic.properties.contains(.read) {
                    print("\(thisCharacteristic.uuid): properties contains .read")
                }
                if thisCharacteristic.properties.contains(.notify) {
                    print("\(thisCharacteristic.uuid): properties contains .notify")
                }
                if thisCharacteristic.properties.contains(.write) {
                    print("\(thisCharacteristic.uuid): properties contains .write")
                }
                
                //peripheral.readValue(for: thisCharacteristic)
                peripheral.setNotifyValue(true, for: thisCharacteristic)
                //thisCharacteristic.value = "tytyty"
                print(thisCharacteristic as Any)
                /// writting data to peripheral device
                //let d = "FF0000"
                
                //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                if(Switchval.isOn)
                {
                peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                }
                else {
                    var value1: [UInt8] = [0x00, 0x00, 0x00]
                    let data1 = NSData(bytes: &value1, length: value1.count) as Data
                    peripheral.writeValue(data1, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
                }
                    // peripheral.readValue(for: thisCharacteristic)
            }
        }
    }
    
    
    
    func peripheral(_ peripheral: CBPeripheral,didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        
        //print("char value:\(characteristic.value!)")
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        
        print("characteristic uuid: \(characteristic.uuid), value: \(String(describing: characteristic.value))")
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?)
    {
        if let error = error {
            print("error: \(String(describing: error))")
            return
        }
        print( characteristic)
        print("Succeeded!")
        
        manager.cancelPeripheralConnection(peripheral)
    }
    
    func hexaToBytes(_ hexa: String) -> [UInt8] {
        var position = hexa.startIndex
        return (0..<hexa.decomposedStringWithCanonicalMapping.count/2).flatMap { _ in
            defer { position = hexa.index(position, offsetBy: 2) }
            return UInt8(hexa[position...hexa.index(after: position)], radix: 16)
        }
    }
    
    
}

