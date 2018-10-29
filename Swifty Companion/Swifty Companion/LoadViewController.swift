//
//  LoadViewController.swift
//  Swifty Companion
//
//  Created by Hendrik STANDER on 2018/10/29.
//  Copyright © 2018 Hendrik STANDER. All rights reserved.
//

import UIKit

class LoadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       
    
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EmbededLaunch"{
            let vc = segue.destination.view
            
            let image = UIImage(named: "wethinkcode-logo-loading")
//            var imageview = UIImageView(image: image)
            var imageview = vc!.subviews[0] as! UIImageView
            imageview.image = image
        }
    }
}



