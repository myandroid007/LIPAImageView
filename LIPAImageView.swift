//
//  LIPAImageView.swift
//  Matchmaker
//
//  Created by liyoro on 15/7/27.  blog:www.liyoro.com. Email:liyoro@163.com
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

import UIKit
import Darwin
import SDWebImage

let backgroundProgressColor = UIColor.redColor()
let progressColor           = UIColor.lightGrayColor()
let kLineWidth              = CGFloat(3.0)
let cache_identifier        = "li.imagecache";

protocol PAImageViewDelegate {
    func paImageViewDidTapped(view: UIView)
}

public class LIPAImageView: UIView {
    var delegate:PAImageViewDelegate!
    
    private func rad(degrees:CGFloat)->CGFloat {
        let pi = M_PI 
        return degrees/CGFloat(180.0/pi)
    }
    
    private var backgroundLayer:CAShapeLayer = CAShapeLayer()
    private var progressLayer:CAShapeLayer = CAShapeLayer()
    private var progressContainer:UIView!
    private var containerImageView:UIImageView!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configure()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.configure()
    }
    
    private func configure() {
        self.layer.cornerRadius     = CGRectGetWidth(self.bounds)/2
        self.layer.masksToBounds    = false;
        self.clipsToBounds          = true;
        
        var arcCenter               = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        var radius                  = min(CGRectGetMidX(self.bounds)-1, CGRectGetMidY(self.bounds)-1);
        var circlePath              = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: -rad(90), endAngle: rad(360-90), clockwise: true)
        
        backgroundLayer.path        = circlePath.CGPath
        backgroundLayer.strokeColor = backgroundProgressColor.CGColor
        backgroundLayer.fillColor   = UIColor.clearColor().CGColor
        backgroundLayer.lineWidth   = kLineWidth
        
        progressLayer.path          = backgroundLayer.path
        progressLayer.strokeColor   = progressColor.CGColor
        progressLayer.fillColor     = backgroundLayer.fillColor
        progressLayer.lineWidth     = backgroundLayer.lineWidth
        progressLayer.strokeEnd     = 0
        
        progressContainer = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        progressContainer.layer.cornerRadius    = CGRectGetWidth(self.bounds)/2
        progressContainer.layer.masksToBounds   = false
        progressContainer.clipsToBounds         = true
        progressContainer.backgroundColor       = UIColor.clearColor()
        
        containerImageView = UIImageView(frame: CGRectMake(1, 1, frame.size.width-2, frame.size.height-2))
        containerImageView.layer.cornerRadius   = CGRectGetWidth(self.bounds)/2
        containerImageView.layer.masksToBounds  = false
        containerImageView.clipsToBounds        = true
        containerImageView.contentMode          = UIViewContentMode.ScaleAspectFill
        
        progressContainer.layer.addSublayer(backgroundLayer)
        progressContainer.layer.addSublayer(progressLayer)
        
        self.addSubview(containerImageView)
        self.addSubview(progressContainer)
        
        let handleSingleTap : Selector = "handleSingleTap:"
        var tapRecognizer = UITapGestureRecognizer(target: self, action: handleSingleTap)
        self.addGestureRecognizer(tapRecognizer) 
    }
    
    private func handleSingleTap(sender: AnyObject) {
        if (self.delegate != nil) {
            self.delegate.paImageViewDidTapped(self)
        }
    }
    
    func setImageURL(imageURL: String) {
        var urlRequest = NSURLRequest(URL: NSURL(string: imageURL)!)
        
        var cacheKey = String(imageURL.hash).stringByAppendingPathComponent(cache_identifier)
        println(cacheKey)
        
        SDImageCache.sharedImageCache().queryDiskCacheForKey(cacheKey, done: { (image, cacheType) in
            /**
             *  显示图片
             */
            if (image != nil) {
                self.updateWithImage(image!)
            }
            else {
                /**
                *  缓存并显示图片
                */
                SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: imageURL), options: SDWebImageOptions.ProgressiveDownload, progress: { (receivedSize, expectedSize) in
                    
                    var progress: CGFloat = CGFloat(receivedSize)/CGFloat(expectedSize)
                    self.progressLayer.strokeEnd = progress
                    self.progressLayer.strokeStart = progress
                    
                    }, completed: { (image, error, cacheType, finished, imageURL) in
                        self.updateWithImage(image!)
                        SDImageCache.sharedImageCache().storeImage(image, forKey: cacheKey)
                })
            }
        })
    }
    
    func setImage(image:UIImage) {
        if (image.images != nil) {
            self.updateWithImage(image)
        }
    }
    
    private func updateWithImage(image:UIImage) {
        let duration = 0.3
        let delay    = 0.1
        
        containerImageView.transform = CGAffineTransformMakeScale(0, 0)
        containerImageView.alpha     = 0
        containerImageView.image     = image
        
        UIView.animateWithDuration(duration, animations: { () in
            self.progressContainer.transform        = CGAffineTransformMakeScale(1.1, 1.1)
            self.progressContainer.alpha            = 0
            
            UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.containerImageView.transform   = CGAffineTransformIdentity
                self.containerImageView.alpha       = 1
                }, completion: nil)
            
        }, completion: {finished in
            self.progressLayer.strokeColor = UIColor.whiteColor().CGColor
            UIView.animateWithDuration(duration, animations: { () in
                self.progressContainer.transform    = CGAffineTransformIdentity
                self.progressContainer.alpha        = 1
            })
        })
    }
   
    private func setBackgroundWidth(width:CGFloat) {
        self.backgroundLayer.lineWidth = width;
        self.progressLayer.lineWidth = self.backgroundLayer.lineWidth;
    }
}
