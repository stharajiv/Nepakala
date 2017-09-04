//
//  UserProfileViewController.swift
//  Nepakala
//
//  Created by Rajiv Shrestha on 7/26/17.
//  Copyright © 2017 rb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import SVProgressHUD

class UserProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var hit_total: UILabel!
    @IBOutlet var Firstname: UILabel!
    @IBOutlet var uname: UILabel!
    @IBOutlet var likes_tot: UILabel!
    
    @IBOutlet var profImage: UIImageView!
    @IBOutlet var Collvieww: UICollectionView!
    
    @IBOutlet var userDataCollView: UICollectionView!
    
    var userprof : [String:Any]?
    var allImages:Array<[String:Any]> = []
    var allUserDetails:Array<[String:Any]> = []
    var allUserProf:Array<[String:Any]> = []
    var userData:Array<[String:Any]> = []
    
    var userdataDic:Array<[String:Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        fetchUserData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func datafetch() {
        
        
        let uid = userprof?["created_by"]
        userdataDic = getUserDataForId(docId: uid as! Int)
        let pfid = profileid(Id: uid as! Int)
        let usrname = profilename(Id: pfid!)
        uname.text = "\((usrname)!)"
        let fname = firstName(Id: pfid!)
        Firstname.text = "\((fname)!)"
        
        // profile image calling
        let imgViewurl = profilePicLinkForId(Id: uid as! Int)
        let url = URL(string: imgViewurl!)
        profImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
        
        // counting hits
        let hitcountarray : Array<Int> = getViewCountForId(docId:uid as! Int)
        let sum = hitcountarray.reduce(0, +)
        hit_total.text = "\(sum)"
   
        // counting likes
        let likecountarray : Array<Int> = getLikesCountForId(docId: uid as! Int)
        let likessum = likecountarray.reduce(0, +)
        likes_tot.text = "\(likessum)"
        
        
        self.userDataCollView.reloadData()
    
    }
    
    //getting all data again
    private func fetchUserData() {
        SVProgressHUD.show(withStatus: "Fetching User Profile.....")
        Fetcher.getAllData(succees: { dataall in
            
            self.userData = dataall
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
             self.datafetch()
            
        }) { errorMessage in
            let alert = UIAlertController(title: "Oops!", message: errorMessage, preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    
    private func profileUserNameForId(Id: Int) -> String? {
        for user in allUserProf {
            print("")
            if let userId = user["id"] as? NSNumber {
               
                if userId.intValue == Id {
                    return ("\((user["contact_number"])!)")
                }
            }
            
        }
        return nil
    }
    
    private func profilePicLinkForId(Id: Int) -> String? {
        for user in allUserProf {
            print("")
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["profile_pic"])!)")
                }
            }
            
        }
        return nil
    }
    
    private func profileViewsforID(Id: Int) -> String? {
        for user in allUserProf {
            print("")
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["profile_pic"])!)")
                }
            }
        }
        return nil
    }

    private func profileid(Id: Int) -> Int? {
        for profileid in allUserProf {
            if let userId = profileid["id"] as? NSNumber {
                if userId.intValue == Id {
                    return profileid["profile"] as? Int
                }
            }
        }
        return nil
    }
    
    private func profilename(Id: Int) -> String? {
        for user in allUserDetails {
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["username"])!)")
                }
            }
        }
        return nil
    }
    
    private func firstName(Id: Int) -> String? {
        for user in allUserDetails {
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["first_name"])!)")
                }
            }
        }
        return nil
    }
    
    private func lastName(Id: Int) -> String? {
        for user in allUserDetails {
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["last_name"])!)")
                }
            }
        }
        return nil
    }
    
    private func profileViews(Id: Int) -> String? {
        for user in allUserDetails {
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["last_name"])!)")
                }
            }
        }
        return nil
    }
    
    private func profileFollowers(Id: Int) -> String? {
        for user in allUserDetails {
            if let userId = user["id"] as? NSNumber {
                
                if userId.intValue == Id {
                    return ("\((user["last_name"])!)")
                }
            }
        }
        return nil
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userdataDic.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userdata", for: indexPath) as! UserProfileCollectionViewCell
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.white.cgColor
        
        let contents = userdataDic[indexPath.row]
        
        cell.img_Name.text = contents["title"] as! String?
        
        let cate : String = String(describing: (contents["category"])!)
        switch cate {
        case "1":
            cell.categorySel.text = "Sketch"
            break
        case "2":
            cell.categorySel.text = "Painting"
            break
        case "3":
            cell.categorySel.text = "Sculputre"
            break
        case "4":
            cell.categorySel.text = "Photo"
            break
        case "5":
            cell.categorySel.text = "Thanka"
            break
        default:
            break
        }
 
        cell.img_likes.text = String(describing: ((JSON(contents)["likes"].array?.count)!))
        cell.img_views.text = String(describing: (contents["hit_count"])!)
        
        let userid = contents["created_by"] as! Int
        let pfid = profileid(Id: userid)
        let usrname = profilename(Id: pfid!)
        cell.usrname.text = "\((usrname)!)"
        
        // for calling image
        let sharedocid = contents["id"] as! Int
        let imglinks : Array<String>  = getImagesForId(docId: sharedocid)
        let imgdata = imglinks.count - 1
        let url = URL(string: (imglinks[imgdata]))
        cell.imgView.sd_setImage(with: url, placeholderImage: UIImage(named: ""))

        
        return cell
    }
    
    private func getUserDataForId(docId:Int) -> Array<[String:Any]> {
        
        var datauserdic:Array<[String:Any]> = []
        
        for data in userData {
            let dataID = data["created_by"] as? NSNumber
            
            let idInt = dataID?.intValue
            
            if let shared_id = idInt {
                if  shared_id == docId {
                    
                    let datalink = data as Dictionary
                    print("User Data: \(datalink)")
                    datauserdic.append(datalink)
                    
                }
            }
            
        }
        return datauserdic 
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
    
    
    private func getViewCountForId(docId:Int) -> Array<Int> {
        
        var viewCountArray: Array<Int> = []
        
        for views in userData {
            let viewsId = views["created_by"] as? NSNumber
            
            let idInt = viewsId?.intValue
            
            if let shared_id = idInt {
                if  shared_id == docId {
                    
                    let hitcounts = views["hit_count"] as! Int
                    viewCountArray.append(hitcounts)
                    
                }
            }
            
        }
        return viewCountArray
    }
    
    private func getLikesCountForId(docId:Int) -> Array<Int> {
        
        var likesCountArray: Array<Int> = []
        
        for likes in userData {
            let likesId = likes["created_by"] as? NSNumber
            
            let idInt = likesId?.intValue
            
            if let shared_id = idInt {
                if  shared_id == docId {
                    
                    let likelink = likes["likes"] as! Array<Int>
                    let likestot = likelink.count
//                        likes["likes"].array?.count
                    likesCountArray.append(likestot)
                    
                }
            }
            
        }
        return likesCountArray
    }

 
}


