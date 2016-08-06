//
//  StickerView.swift
//  SocialApp
//
//  Created by Administrator on 14/07/16.
//  Copyright © 2016 Inheritx. All rights reserved.
//

import UIKit

protocol MyDeleteDelegate
{
    func setStickerObject()
    func setDeleteFrame()
}


class ClsSticker: NSObject {
    
    var strImageName:String!
    init(pdictResponse:[String:AnyObject]) {
    strImageName = pdictResponse["sticker_name"] as! String
        
    }
}
class StickerView: UIView,UIGestureRecognizerDelegate {
    
    @IBOutlet var imgSticker: UIImageView!
    @IBOutlet var btnCloseView: UIButton!
    
    var delegate : MyDeleteDelegate! = nil

    
    var deleterectFrame : CGRect!
    var firstX : CGFloat!
    var lastPoint : CGPoint!
    var firstY : CGFloat!
    var deleteInFrame : Bool!
    var objPanGesture : UIPanGestureRecognizer!
    let objAppdelegate = UIApplication.sharedApplication().delegate
    var WindowHeight : CGFloat!
    var WindowWidth : CGFloat!
    var lastScale : CGFloat!
    
    static func getSticker(pobjSticker:ClsSticker) -> StickerView {
        
        let objStickerView:StickerView = NSBundle.mainBundle().loadNibNamed("StickerView", owner: self, options: nil)[0] as! StickerView
        
        objStickerView.imgSticker.image =  UIImage(named: pobjSticker.strImageName)
        objStickerView.imgSticker.contentMode = .ScaleAspectFit
        objStickerView.backgroundColor = UIColor.clearColor()
        return objStickerView
    }
    
    
    func addGestures(){
        
        WindowHeight = (UIApplication.sharedApplication().delegate!.window?!.frame.size.height)
        WindowWidth = (UIApplication.sharedApplication().delegate!.window?!.frame.size.width)
        
        let objTapGesture = UITapGestureRecognizer(target: self, action: "tapGestureReceived:")
        objTapGesture.numberOfTapsRequired = 1
        objTapGesture.delegate = nil
        self.addGestureRecognizer(objTapGesture)
        
        
        let objPinchGesture = UIPinchGestureRecognizer(target: self, action: "pinchGestureReceived:")
        objPinchGesture.delegate = self
        self.addGestureRecognizer(objPinchGesture)
        
        objPanGesture = UIPanGestureRecognizer(target: self, action: "panGestureReceived:")
        objPanGesture.delegate = self
        self.addGestureRecognizer(objPanGesture)
        
        let objRotationGesture = UIRotationGestureRecognizer(target: self, action: "rotationGestureReceived:")
        objRotationGesture.delegate = nil
        self.addGestureRecognizer(objRotationGesture)
    }
    
    func tapGestureReceived(pobjGesture:UITapGestureRecognizer) {
        
        btnCloseView.hidden = !btnCloseView.hidden
    }
    
    //Niharika added this for Rotation
    func rotationGestureReceived(pobjGesture:UIRotationGestureRecognizer) {
        print("Rotating")
        pobjGesture.view!.transform = CGAffineTransformRotate(pobjGesture.view!.transform, pobjGesture.rotation);
        pobjGesture.rotation = 0.0;
    }
    
    func panGestureReceived(pobjGesture:UIPanGestureRecognizer) {
        btnCloseView.hidden = true
        let translate = pobjGesture.translationInView(self.superview)
        if pobjGesture.state == UIGestureRecognizerState.Began {
            firstX = pobjGesture.view!.center.x
            firstY = pobjGesture.view!.center.y
        }
        
        let xPos = firstX+translate.x
        let yPos = firstY+translate.y
        
        if pobjGesture.state == UIGestureRecognizerState.Changed {
            if xPos > 0 && yPos > 0 && xPos < WindowWidth && yPos < (WindowHeight! - 50.0) {
                pobjGesture.view!.center = CGPoint(x:pobjGesture.view!.center.x + translate.x,
                    y:pobjGesture.view!.center.y + translate.y)
                let isPointInFrame = CGRectContainsPoint(UIScreen.mainScreen().bounds, pobjGesture.view!.center)
                if isPointInFrame == true{
                    lastPoint = pobjGesture.view!.center
                }
                
                //For checking intersect of two Rect Frames(Sticker frame and delete button Frame)
                deleteInFrame = CGRectIntersectsRect(deleterectFrame, pobjGesture.view!.frame)
                if deleteInFrame == true {
                    print("DELETEEEE....")
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        self.delegate?.setStickerObject()
                    })
                }
                else {
                    delegate?.setDeleteFrame()
                }
                
                pobjGesture.setTranslation(CGPointZero, inView: self.superview)
            }
            
        }
        
        if pobjGesture.state == UIGestureRecognizerState.Ended {
            let isPointInFrame = CGRectContainsPoint(UIScreen.mainScreen().bounds, pobjGesture.view!.center)
            print(isPointInFrame)
            pobjGesture.view!.center = self.lastPoint
            pobjGesture.setTranslation(CGPointZero, inView: self.superview)
            
            deleteInFrame = CGRectIntersectsRect(deleterectFrame, pobjGesture.view!.frame)
            if deleteInFrame == true {
                pobjGesture.view?.hidden = true
            }
            delegate?.setDeleteFrame()
            
        }
    }
    
    func pinchGestureReceived(pobjPinchGesture:UIPinchGestureRecognizer) {
        btnCloseView.hidden = true
        print("PINCHINGGG....")
        //For managing Zoom Level of pinching
        if pobjPinchGesture.state == .Began {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = pobjPinchGesture.scale
        }
        if pobjPinchGesture.state == .Began || pobjPinchGesture.state == .Changed {
            
            let currentScale: CGFloat = pobjPinchGesture.view!.layer.valueForKeyPath("transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale: CGFloat = 2.0
            let kMinScale: CGFloat = 0.5
            var newScale: CGFloat = 1 - (lastScale - pobjPinchGesture.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform: CGAffineTransform = CGAffineTransformScale(pobjPinchGesture.view!.transform, newScale, newScale)
            pobjPinchGesture.view!.transform = transform
            lastScale = pobjPinchGesture.scale
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func assignNewFrame(frame : CGRect){
        self.imgSticker.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        self.frame = CGRectMake(frame.origin.x,frame.origin.y,frame.size.width, frame.size.height)
    }
    
    @IBAction func btnCloseViewClicked (sender: UIButton){
        self.removeFromSuperview()
    }
    
}
