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

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var UICollView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        [self setAutomaticallyAdjustsScrollViewInsets:NO];
        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        //testing of the git hub
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Btn_Login(_ sender: Any) {
        
        let sb = self.storyboard
        let VC = sb?.instantiateViewController(withIdentifier: "LoginScene")
        self.navigationController?.pushViewController(VC!,  animated : true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 40
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      
       
        return cell

    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = self.storyboard
        let VC = sb?.instantiateViewController(withIdentifier: "ImageSelected")
        self.navigationController?.pushViewController(VC!, animated: true)
    }
    
}

