//
//  CollectionViewController.swift
//  LightBLU
//
//  Created by POTHULA, SANDEEP RAJ SUDARSHAN on 2/21/18.
//  Copyright © 2018 POTHULA, SANDEEP RAJ SUDARSHAN. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
   
    
    let Imagesarry=[UIImage(named:"8.jpg"),UIImage(named:"7.jpg"),UIImage(named:"m.jpg"),UIImage(named:"10.jpg"),UIImage(named:"5.jpg"),UIImage(named:"6.jpg"),]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

 
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Imagesarry.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells = collectionView.dequeueReusableCell(withReuseIdentifier:"MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cells.Images.image = Imagesarry[indexPath.row]
        //cells.ImgLb.text = "image 1"
        return cells
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard:UIStoryboard = UIStoryboard(name:"Main", bundle : nil)
        switch(indexPath.row)
        {
            
        case 0:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "BluetoothScreenViewController") as! BluetoothScreenViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        
                    break
        case 1:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "LEDScreenViewController") as! LEDScreenViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        
                    break
        case 2:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "AppleScreenViewController") as! AppleScreenViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        
                    break
        case 3:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "QRScanViewController") as! QRScanViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        
                    break
        case 4:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "SettingsScreenViewController") as! SettingsScreenViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        case 5:     print(indexPath.row)
                    let desVC = mainStoryboard.instantiateViewController(withIdentifier: "ScheduleScreenViewController") as! ScheduleScreenViewController
                    self.navigationController?.pushViewController(desVC, animated: true)
        
                    break
        
            
            
        default:    print("in Default")
                    break
        }
        }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
