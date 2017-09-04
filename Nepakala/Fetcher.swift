//
//  Fetcher.swift
//  Nepakala
//
//  Created by Rajiv Shrestha on 8/18/17.
//  Copyright © 2017 rb. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON
import SVProgressHUD

class Fetcher {
   
    
    static func getAllImages(sucees: @escaping (_ images: [[String:Any]]) -> (), failure: @escaping (_ errorMessage: String)  -> () ) {
      
        let url = URL(string: "http://nepakala.com/nepakala-apis/images/")
        let header = ["Content-Type": "application/json"]
        
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            SVProgressHUD.dismiss()
            var allImages: [[String:Any]] =  []
            
            switch response.result{
            case.success(let value):
                if    let swiftyJsonArray = JSON(value).arrayObject  {
                    for images in swiftyJsonArray {
                        if   let alimages =   JSON(images).dictionaryObject {
                            //                            print("All Images: \(alimages)")
                            allImages.append(alimages)
                            
                        }}
                }
                
                sucees(allImages)
                
                break
                
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }}
        
    }
    
    static func getAllUserDetails(succees: @escaping (_ userdetails: [[String:Any]]) -> (), failure: @escaping (_ errorMessage: String)  -> () ) {
        
        let url = URL(string: "http://nepakala.com/nepakala-apis/users/")
        let header = ["Content-Type": "application/json"]
        
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            //            SVProgressHUD.dismiss()
            
            var allUserDetails: [[String:Any]] =  []
            
            switch response.result{
            case.success(let value):
                if    let swiftyJsonArray = JSON(value).arrayObject  {
                    for userDet in swiftyJsonArray {
                        if   let userdetails =   JSON(userDet).dictionaryObject {
                            //                            print("userprofiles: \(userprofiles)")
                            allUserDetails.append(userdetails)
                        }}
                }
                succees(allUserDetails)
                break
                
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }}
    
    }
    
     static func getAllUserProfiles(succees: @escaping (_ userprofiles: [[String:Any]]) -> (), failure: @escaping (_ errorMessage: String)  -> () ) {
    
        let url = URL(string: "http://nepakala.com/nepakala-apis/user-profiles/")
        let header = ["Content-Type": "application/json"]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in

            var allUserProf: [[String:Any]] =  []
            
            switch response.result{
            case.success(let value):
                if    let swiftyJsonArray = JSON(value).arrayObject  {
                    for userDic in swiftyJsonArray {
                        if   let userprofiles =   JSON(userDic).dictionaryObject {
                            //                            print("userprofiles: \(userprofiles)")
                            allUserProf.append(userprofiles)
                        }
                    }
                }
                succees(allUserProf)
                break
                
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }}
        
    }
    
    static func getAllData(succees: @escaping (_ allInfoData: [[String:Any]]) -> (), failure: @escaping (_ errorMessage: String)  -> () ) {
        
        let url = URL(string: "http://nepakala.com/nepakala-apis/shared-documents/")
        let header = ["Content-Type": "application/json"]
        
        SVProgressHUD.show(withStatus: "Connecting.....")
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            var allData: [[String:Any]] =  []
            
            switch response.result{
            case.success(let value):
                if    let swiftyJsonArray = JSON(value).arrayObject  {
                    for dataDic in swiftyJsonArray {
                        if   let alldatainfo =   JSON(dataDic).dictionaryObject {
                            allData.append(alldatainfo)
                        }
                    }
                }
                succees(allData)
                break
                
            case .failure(let error):
                failure(error.localizedDescription)
                break
            }}

    }
}
