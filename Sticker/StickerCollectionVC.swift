//
//  StickerCollectionVC.swift
//  Sticker
//
//  Created by Niharika Rajpurohit on 06/08/16.
//  Copyright © 2016 inheritx. All rights reserved.
//

import UIKit

protocol MyStickerDelegate
{
    func setstickerimg(imageName: Int8)
}

class StickerCollectionVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    let identifier = "StickerCell"
    @IBOutlet weak var collectionView: UICollectionView!
    var objStickerView  : StickerView!
    var delegate1 : MyStickerDelegate! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource  = self
        collectionView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 23
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cellIdentifier:String = identifier;
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier,forIndexPath:indexPath) as! StickerCell
        let imgname:String = String(format: "%.d.png", indexPath.row+1)
        cell.img_sticky.image = UIImage(named: imgname)
        return cell
    }
    
     func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row+1)
        self.showSticker(indexPath.row+1)
        
    }
    
    func showSticker(index: Int8) {
        print(index)
        self.delegate1?.setstickerimg(index)
        self .dismissViewControllerAnimated(true, completion:nil)
    }
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
