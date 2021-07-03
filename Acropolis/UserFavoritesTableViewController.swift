//
//  UserFavoritesTableViewController.swift
//  Acropolis
//
//  Created by ehsan sat on 7/2/21.
//  Copyright © 2021 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserFavoritesTableViewController: UITableViewController {
    
    var doiArr = [String]()
    
    var workTitle = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var workDOI = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    var author = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var publisher: String? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var ref: DatabaseReference?
    
    let user = Auth.auth().currentUser

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref?.child("Users").child(user!.uid).child("Titles").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            if let titles = snapshot.value as? [String] {
                self.workTitle = titles
            }
        })
        ref?.child("Users").child(user!.uid).child("Authors").observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value)
            if let authors = snapshot.value as? [String] {
                self.author = authors
            }
        })

    }
    
//    func makeRequest() {
//        let url = URL(string: "https://api.crossref.org/works?query=\(givenDoi)")
//
//        NetworkManager().getDataFromAPI(url: url!, successHandler: { (data) in
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
//                let jsonDic = json as! [String: Any]
//                let work = jsonDic["message"] as! [String: Any]
//                let items = work["items"] as! [Any]
//                for item in items {
//                    // get title, author, publisher
//                    let itemDic = item as! [String: Any]
//                    let title = itemDic["title"] as! [Any]
//                    self.workTitle.append("\(title.first ?? " ")")
////                    let doi = itemDic["DOI"] as! String
////                    print(doi)
////                    self.workDOI.append("\(doi)")
//                    if let author = itemDic["author"] as? [Any], let authorDic = author.first as? [String: Any] {
//
//                        let authorName = "\(authorDic["given"] ?? " ")" + " " + "\(authorDic["family"] ?? " ")"
//                        self.author.append(authorName)
//                    } else {
//                        self.author.append("No Author Was Found")
//                    }
//
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                    print("table view reload data")
//                }
//            } catch {
//                print(error)
//            }
//        }) { (error) in
//            print(error)
//        }
//
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workTitle.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
        
        if self.workTitle.count == self.author.count {
            cell.textLabel?.text = self.workTitle[indexPath.row]
            cell.detailTextLabel?.text = self.author[indexPath.row]
        } else {
            print("^^^^^^^")
        }
        // Configure the cell...

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
