//
//  ViewController.swift
//  Sticker
//
//  Created by Niharika Rajpurohit on 19/07/16.
//  Copyright © 2016 inheritx. All rights reserved.
//

import UIKit
import AssetsLibrary

extension UIView{
    
    var screenshot: UIImage{
        
        
        UIGraphicsBeginImageContext(self.bounds.size);
        let context = UIGraphicsGetCurrentContext();
        self.layer.renderInContext(context!)
        let screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return screenShot
    }
}

class ViewController: UIViewController,MyDeleteDelegate,MyStickerDelegate {
    
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var imgSticker: UIImageView!
    @IBOutlet var viewMenu: UIView!
    @IBOutlet var img_Sticker: UIImageView!
    @IBOutlet var btn_save: UIButton!
    @IBOutlet var btn_Marge: UIButton!
    @IBOutlet var img_background: UIImageView!
    @IBOutlet var btn_Smily: UIButton!
    var objStickerView  : StickerView!
    var objstickercollectionVC : StickerCollectionVC!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  //Delegate for highlighting Delete Button
    func setStickerObject() {
        UIView.animateWithDuration(0.2) { () -> Void in
              self.btnDelete.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }
        
    }
    
    //Delegate for delete button Normal Position
    func setDeleteFrame() {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.btnDelete.transform = CGAffineTransformMakeScale(1, 1);
        }
        
    }
    
    @IBAction func saveClick(sender: AnyObject) {
        
    }

    @IBAction func smily_click(sender: UIButton) {
        self.performSegueWithIdentifier("StickerCollctionVC", sender: nil)
    }
    
    @IBAction func margeClick(sender: AnyObject) {
        viewMenu.hidden = true
        let screenshot = view.screenshot
        imgSticker.image = screenshot

    }
    
    func setstickerimg(imageName: Int8) {
        let imgname:String = String(format: "%.d.png", imageName)
        let objTempSticker = ClsSticker(pdictResponse: ["sticker_name":imgname])
        objStickerView = StickerView.getSticker(objTempSticker)
        objStickerView.delegate = self
        objStickerView.addGestures()
        objStickerView.frame = CGRectMake(20, 20, 150 , 150)
        objStickerView.imgSticker.frame = objStickerView.frame
        objStickerView.deleterectFrame = btnDelete.frame
        self.view .addSubview(objStickerView)
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.bringSubviewToFront(viewMenu)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StickerCollctionVC" {
            let secondViewController = segue.destinationViewController as! StickerCollectionVC
            secondViewController.delegate1 = self
        }
    }
}

