//
//  ViewController.swift
//  Nepakala
//
//  Created by Rajiv Shrestha on 7/20/17.
//  Copyright © 2017 rb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import Realm
import RealmSwift
import SwiftyJSON
import SDWebImage

//private class globals {
//var allData:Array<[String:Any]> = []
//var allUserProf:Array<[String:Any]> = []
//var allUserDetails:Array<[String:Any]> = []

//}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var selectedcat:Int?
    var allImages:Array<[String:Any]> = []
    var allUserDetails:Array<[String:Any]> = []
    var allUserProf:Array<[String:Any]> = []
    var allData:Array<[String:Any]> = []
//    var imglinks:Array<String> = []
    var tmpimglink:[Any] = []
    var imglinks:[String:Array<Any>] = [:]
    
    @IBOutlet var menuView: UIView!
    @IBOutlet var UICollView: UICollectionView!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var menuBtn: UIButton!
    @IBOutlet var categoryView: UIView!
    var CategoryShowing = false
    @IBOutlet var TopConstraint: NSLayoutConstraint!
    
    @IBOutlet var allDataColl: UICollectionView!
    
    var usernameprof:Array<Any>?
    var test = [String:String]()
    var hitCount:Array<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        categoryView.layer.shadowOpacity = 0.5
        categoryView.layer.shadowRadius = 3
        categoryView.layer.shadowColor = UIColor.darkGray.cgColor
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        //fetching the data
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("\(self.selectedcat )")
        if (self.selectedcat != nil) {
            self.allDataColl.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //login button click
    @IBAction func Btn_Login(_ sender: Any) {
        
        let sb = UIStoryboard.init(name: "LoginScreen", bundle: nil)
        let VC = sb.instantiateViewController(withIdentifier: "loingscreen")
        self.navigationController?.pushViewController(VC,  animated : true)
    }
    
    //filling up the collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allData.count
   
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "alldatacell", for: indexPath) as! MainScreenCollectionViewCell

        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        
        let contents = allData[indexPath.row]
        
        cell.Img_Name.text = contents["title"] as! String?
        let ImgVws : String = String(describing: (contents["hit_count"])!)
            cell.Img_Views.text = ImgVws
        let ImgLikes = String(describing: ((JSON(contents)["likes"].array?.count)!))
        cell.Likes.text = ImgLikes
        
    
        let cate : String = String(describing: (contents["category"])!)
        switch cate {
            case "1":
                cell.Category.text = "Sketch"
                break
            case "2":
                cell.Category.text = "Painting"
                break
            case "3":
                cell.Category.text = "Sculputre"
                break
            case "4":
                cell.Category.text = "Photo"
                break
            case "5":
                cell.Category.text = "Thanka"
                break
            default:
                break
        }

        
        let userid = contents["created_by"] as! Int
        let pfid = profileid(Id: userid)
        let usrname = profilename(Id: pfid!)
        cell.User_Name.text = "\((usrname)!)"
        
        // for calling image
        let sharedocid = contents["id"] as! Int
        let imglinks : Array<String>  = getImagesForId(docId: sharedocid)
        let imgdata = imglinks.count - 1
        let url = URL(string: (imglinks[imgdata]))
        cell.img_View.sd_setImage(with: url, placeholderImage: UIImage(named: ""))

        
        
        return cell

    }
    
    private func getImagesForId(docId:Int) -> Array<String> {
        
        var photosArray: Array<String> = []
        
        for image in allImages {
            let photId = image["shared_document"] as? NSNumber
            
            let idInt = photId?.intValue
            
            if let shared_id = idInt {
                if  shared_id == docId {
                   
                    let imageLink = image["photos"] as! String
                    photosArray.append(imageLink)
                    
                }
            }
            
        }
        return photosArray
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard.init(name: "UserProfile", bundle: nil)
        let VC = sb.instantiateViewController(withIdentifier: "userprofile") as! UserProfileViewController
        let usrprof = allData[indexPath.row]
        VC.userprof = usrprof
        
//        VC.testprof = test
        

        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    @IBAction func Category_Btn(_ sender: Any) {
        
        if (CategoryShowing) {
            TopConstraint.constant = -218
        } else {
            TopConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: { 
                self.view.layoutIfNeeded()
            })
            
        }
        CategoryShowing = !CategoryShowing
        
    }
    
    private func fetchData() {
        
        Fetcher.getAllData(succees: { dataall in
            
            self.allData = dataall
            self.fetchUserProf()
            
        }) { errorMessage in
            let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchUserProf() {
        
        Fetcher.getAllUserProfiles(succees: { userprofiles in
            
            self.allUserProf = userprofiles
            self.fetchUserDetails()
            
        }) { errorMessage in
            let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func fetchUserDetails() {
        
        Fetcher.getAllUserDetails(succees: { userdetails in
            self.allUserDetails = userdetails
            self.fetchImages()
            
        }) { errorMessage in
            let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func fetchImages() {
        
        Fetcher.getAllImages(sucees: { images in
            
            self.allImages = images
            self.allDataColl.reloadData()
            print("\(images)")
            
        }) { errorMessage in
            let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
                            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                            })
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
        }
    }

    

    private func profileid(Id: Int) -> Int? {
//                print("\(allUserProf)")
        for profileid in allUserProf {
//            print("")
            if let userId = profileid["id"] as? NSNumber {
                
                if userId.intValue == Id {
//                    print("Profile ID :\(profileid["profile"])")
                    return profileid["profile"] as? Int
//                    print("Profile ID \(profileid["profile"])")
                }
            }
            
        }
        return nil
    }
    
    private func profilename(Id: Int) -> String? {
        //        print("\(allUserDetails)")
        for user in allUserDetails {
//            print("")
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
//                    print("Username :\(user["username"])")
                    
                    return ("\((user["username"])!)")
                    //                    print("Profile ID \(user["profile"])")
                }
            }
            
        }
        return nil
    }
    
    private func mainImage(Id: Int) -> Array<String>? {
        //        print("\(allImages)")
        var testarr:[String] = []
        for image in allImages {
//            print("")
            if let userId = image["shared_document"] as? NSNumber {
                
                if userId.intValue == Id {
//                    print("Image Links :\(image["photos"])")
                    testarr.append((image["photos"] as? String)!)
                    
                                        print("Image Links \(image["photos"])")
                }
            }
         print("\n photos: \(testarr)")
        return testarr
           
        }
            return nil
    }

}

