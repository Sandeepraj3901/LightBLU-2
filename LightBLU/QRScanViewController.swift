//
//  QRScanViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import AVFoundation
import CoreBluetooth

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, CBCentralManagerDelegate, CBPeripheralDelegate{
   var password: String = ""
    var qrtext: String = ""
    var name: String = " "
    var NAME: String = "LED BLU"
    var status = ""
    let B_UUID =
        CBUUID(string: "0000AB09-D102-11E1-9B23-00025B00A5A5")
    //0000AB07-D102-11E1-9B23-00025B00A5A5
    //let Device = CBUUID(string: "0x1800")
    let Devicec = CBUUID(string: "0x2A00")
    let BSERVICE_UUID =
        CBUUID(string: "0000AB08-D102-11E1-9B23-00025B00A5A5")
    var manager:CBCentralManager!
    var peripherals:CBPeripheral!
    @IBOutlet weak var messageLabel: UILabel!
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                      AVMetadataObject.ObjectType.code39,
                                      AVMetadataObject.ObjectType.code39Mod43,
                                      AVMetadataObject.ObjectType.code93,
                                      AVMetadataObject.ObjectType.code128,
                                      AVMetadataObject.ObjectType.ean8,
                                      AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.aztec,
                                      AVMetadataObject.ObjectType.pdf417,
                                      AVMetadataObject.ObjectType.itf14,
                                      AVMetadataObject.ObjectType.dataMatrix,
                                      AVMetadataObject.ObjectType.interleaved2of5,
                                      AVMetadataObject.ObjectType.qr]
    
    @IBOutlet weak var codelb: UILabel!
    //var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBAction func scanbtn(_ sender: Any) {
        // Get the back-facing camera for capturing videos
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
        
        // Move the message label and top bar to the front
        view.bringSubview(toFront: messageLabel)
        //view.bringSubview(toFront: topbar)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == false) {
            captureSession.stopRunning()
         
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "QR Scan"
        view.backgroundColor = UIColor.black
      
        
    }
    
    
    func launchApp(decodedURL: String) {
        
        if presentedViewController != nil {
            return
        }
        
        let alertPrompt = UIAlertController(title: "Open App", message: "You're going to open \(decodedURL)", preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            if let url = URL(string: decodedURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        alertPrompt.addAction(confirmAction)
        alertPrompt.addAction(cancelAction)
        
        present(alertPrompt, animated: true, completion: nil)
    }
    
    
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            let alert = UIAlertController(title: "Enter Master Password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            if metadataObj.stringValue != nil
            {
                
                //launchApp(decodedURL: metadataObj.stringValue!)
                //messageLabel.text = metadataObj.stringValue
                //_ = navigationController?.popViewController(animated: true)
                // let vc:QRScanViewController = QRScanViewController()
                messageLabel.text = metadataObj.stringValue
                if( metadataObj.stringValue == "12345678")
                {
                    self.captureSession.stopRunning()
                    view.willRemoveSubview(qrCodeFrameView!)
                    qrtext = messageLabel.text!
                    
                    
                    alert.addTextField(configurationHandler: { textField in
                        textField.placeholder = "Input your password here..."
                        //textField.placeholder = "Password"
                        textField.isSecureTextEntry = true
                        
                    })
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        
                        if let name = alert.textFields?.first?.text {
                            //print("Your name: \(name)")
                            self.password = name
                            print("Your QRCODE: \(self.qrtext)")
                            print("Your Password: \(self.password)")
                            
                            if(self.password == "Sandy")
                            {
                                //self.manager = CBCentralManager(delegate: self, queue: nil)
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.password = self.password
                               
                                appDelegate.dstatus = "Connected"
                                self.manager = CBCentralManager(delegate: self, queue: nil)
                                }
                            else {
                                let alert3 = UIAlertController(title: "Deviced Not Paired - Please check", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                                alert3.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                                self.present(alert3, animated: true)
                            }
                        }
                    }))
                    
                    self.present(alert, animated: true)
                }
                else{
                    let alert2 = UIAlertController(title: "This is not LED device", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert2, animated: true)
                }
                
                
            }
            
        }
        
    }
   
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBManagerState.poweredOn {
            let alert3 = UIAlertController(title: "Deviced Paired - Please proceed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert3.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert3, animated: true)
            
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
          
           
        }
       
        /* let device = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey )
         as? NSString
         print(String(describing: device))
         //CBAdvertisementDataLocalNameKey
         
         */
        if(peripheral.name != nil )
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
                        self.manager.stopScan()
                    
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
    func centralManager(_ central: CBCentralManager,
                        didConnect peripherals: CBPeripheral)
    {
        print(peripherals)
        print("connected!")
        status = "Connected"
       
        peripherals.delegate = self
        peripherals.discoverServices(nil)
        
        
    }
    // Called when it failed
    func centralManager(_ central: CBCentralManager,
                        didFailToConnect peripheral: CBPeripheral,
                        error: Error?)
    {
        print("failed…")
        status = " Not Connected"
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
                
                
                var value: [UInt8] = [0xFF,0x47,0x9E]
                let data = NSData(bytes: &value, length: value.count) as Data
                let data1: Data = "A51628".data(using: String.Encoding.utf8)!
                print(data1)
                //let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
                peripheral.writeValue(data, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
               peripheral.readValue(for: thisCharacteristic)
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
    
}

/*extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            let alert = UIAlertController(title: "Enter Master Password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            if metadataObj.stringValue != nil
            {
                
                 //launchApp(decodedURL: metadataObj.stringValue!)
                //messageLabel.text = metadataObj.stringValue
                //_ = navigationController?.popViewController(animated: true)
               // let vc:QRScanViewController = QRScanViewController()
                messageLabel.text = metadataObj.stringValue
                if( metadataObj.stringValue == "12345678")
                {
                    self.captureSession.stopRunning()
                qrtext = messageLabel.text!
                
               
                alert.addTextField(configurationHandler: { textField in
                    textField.placeholder = "Input your password here..."
                    //textField.placeholder = "Password"
                    textField.isSecureTextEntry = true
                   
                })
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                    if let name = alert.textFields?.first?.text {
                        //print("Your name: \(name)")
                        self.password = name
                        print("Your QRCODE: \(self.qrtext)")
                        print("Your Password: \(self.password)")
                        
                    }
                }))
               
                self.present(alert, animated: true)
            }
                else{
                    let alert2 = UIAlertController(title: "This is not LED device", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                     alert2.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert2, animated: true)
                }
        }
            
        }
    
    }
  
}*/
