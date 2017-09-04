//
//  MainMenuTableViewController.swift
//  Nepakala
//
//  Created by Rajiv Shrestha on 7/28/17.
//  Copyright © 2017 rb. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class MainMenuTableViewController: UITableViewController {

    var Category:Array<[String:Any]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let topMargin = UIApplication.shared.statusBarFrame.height
        
        self.tableView.contentInset = UIEdgeInsets(top: topMargin, left: tableView.layoutMargins.left, bottom: tableView.layoutMargins.bottom, right: tableView.layoutMargins.right)
        
        fetchCategory()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func fetchCategory() {
    
        
        let url = URL(string: "http://nepakala.com/nepakala-apis/categories/")
        let header = ["Content-Type": "application/json"]

        
        SVProgressHUD.show(withStatus: "Fetching Categories")
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (responseData) in
            
            SVProgressHUD.dismiss()
            
            switch responseData.result{
            case.success(let value):
                
                let responseArray = value as! Array<Any>
                for categoryDict:Any in responseArray{
                    
                    let categoryInfo = categoryDict as! [String:Any]
                    self.Category.append(categoryInfo)
                }
                self.tableView.reloadData()
                break
                
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
    

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let cat = "Categories"
        return cat
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Category.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menucell", for: indexPath)

        let categorys = Category[indexPath.row]
        
        let name = categorys["name"] as! String
        
        cell.textLabel?.text = name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cate = Category[indexPath.row]["id"] as! Int
        var id = 0
        repeat
        {
            if cate == id{
                

                let VC = self.storyboard?.instantiateViewController(withIdentifier: "mainx") as! ViewController
                VC.selectedcat = cate
                
//                self.navigationController?.pushViewController(VC, animated: true)
                
            }
            id = id+1
        
        } while id <= Category.count
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
