	//
//  ViewController.swift
//  Swifty Companion
//
//  Created by Hendrik STANDER on 2018/10/19.
//  Copyright © 2018 Hendrik STANDER. All rights reserved.
//

import UIKit
import OAuthSwift
import JSONParserSwift
    
class ViewController: UIViewController {

    @IBOutlet weak var searchTxt: UITextField!
    var deviceToken : String = ""
    var responseText : String = ""
    let oauthswift = OAuth2Swift(
        consumerKey:    "a3f3c25005921c8ba73cfdc685f047674c12f684ab9afe10feefbaea1fd5fd92",
        consumerSecret: "27abd91577e020f3b36acd0c2f5a9cf2b4982246e52f41b1abe3ea8f66f39371",
        authorizeUrl:   "https://api.intra.42.fr/oauth/authorize",
        accessTokenUrl: "https://api.intra.42.fr/oauth/token",
        responseType:   "token"
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var imageView = UIImageView(frame: view.bounds)
        imageView.image = UIImage(named: "wtc-bg")
        imageView.contentMode = UIImageView.ContentMode.scaleAspectFill
        self.view.insertSubview(imageView, at: 0)
 
        
        let handle = oauthswift.authorize(
            deviceToken: self.deviceToken,
            grantType: "client_credentials",
            success: { credential, response, parameters in
                            print(credential.oauthToken)
                            self.deviceToken = credential.oauthToken
                    },
                        failure: { error in
                            print(error.localizedDescription)
                    })
    }

   
    @IBAction func searchBtn(_ sender: UIButton) {
        if let query = searchTxt.text {
        var url = URL(string: "https://api.intra.42.fr/v2/users/" + query)
        var request = URLRequest(url: url!)
        request.httpMethod = "Get"
        request.setValue("Bearer " + self.deviceToken, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request){
            (data, response, error) in
            if error != nil{
                print(error)
            }
            else if let d = data {
                self.responseText =  String(data: d, encoding: String.Encoding.utf8)!
            }

        }
        task.resume()
        while true
        {
            if responseText != "" {
                self.performSegue(withIdentifier: "profileSegue", sender: sender)
                break
            }
        }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! ScrollViewController
        vc.responseText = self.responseText
        self.responseText = ""
    }
    
    @IBAction func unWindSegue(segue: UIStoryboardSegue){
    }

}

