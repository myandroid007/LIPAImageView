//
//  ViewController.swift
//  LIPAImageView
//
//  Created by liyoro on 15/7/28.
//  Copyright (c) 2015年 liyoro. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PAImageViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var testImage = LIPAImageView(frame: CGRectMake(80, 80, 88, 88))
        testImage.setImageURL("http://d.hiphotos.baidu.com/image/pic/item/2f738bd4b31c87016a15c1fe257f9e2f0708ff03.jpg")
        testImage.delegate = self
        self.view.addSubview(testImage)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func paImageViewDidTapped(view: UIView) {
        println("paImageViewDidTapped")
    }

}

