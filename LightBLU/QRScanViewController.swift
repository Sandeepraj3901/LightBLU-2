//
//  QRScanViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
   var password: String = ""
    var qrtext: String = ""
 
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
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers
            for aViewController in viewControllers {
                if aViewController is LEDScreenViewController {
                    let vc:LEDScreenViewController = LEDScreenViewController()
                    vc.idval.text = messageLabel.text
                    self.navigationController!.popToViewController(aViewController, animated: true)
                    
                }
            }
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
                            let alert3 = UIAlertController(title: "Deviced Scanned - Please proceed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                            alert3.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                            self.present(alert3, animated: true)
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
