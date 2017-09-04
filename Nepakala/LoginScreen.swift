//
//  LoginScreen.swift
//  Nepakala
//
//  Created by Rajiv Shrestha on 7/22/17.
//  Copyright © 2017 rb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class LoginScreen: UIViewController {

    @IBOutlet var textUsername: UITextField!
//    @IBOutlet var textEmail: UITextField!
    @IBOutlet var textPwd: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func Btn_Register(_ sender: Any) {
        
        let sb = self.storyboard
        let VC = sb?.instantiateViewController(withIdentifier: "register")
        self.navigationController?.pushViewController(VC!,  animated : true)

        
    }
    
    private func loginscucess(){
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let VC = sb.instantiateViewController(withIdentifier: "mainx")
        self.navigationController?.pushViewController(VC,  animated : true)

        
    }
    
    
    
    @IBAction func btn_Login(_ sender: Any) {
        
        let url = URL(string: "http://nepakala.com/nepakala-apis/login/")
        let params = ["username": textUsername.text!, "password": textPwd.text!]
        
        let header = ["Content-Type": "application/json"]
        
        
        SVProgressHUD.show(withStatus: "Loggin in..")
        
        
        Alamofire.request(url!, method: .post, parameters: params, encoding:JSONEncoding.default, headers: header).responseJSON { (responseData) in
            
            SVProgressHUD.dismiss()
            
            switch responseData.result {
                
            case .success(let value):
                print("Login Successful for \(value)")
                self.loginscucess()
                break
                
//                let data = try! JSONSerialization.data(withJSONObject: value, options: JSONSerialization.WritingOptions.prettyPrinted)
//                let resonseString = String.init(data: data, encoding: String.Encoding.utf8)
                //print(" response  string ------ \(resonseString!)")

            case .failure(let error):
                
                let alert = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
                
                let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                    
                })
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                
                break

            }

        }
        
    }
    

}
