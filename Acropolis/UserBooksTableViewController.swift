//
//  UserBooksTableViewController.swift
//  Acropolis
//
//  Created by ehsan sat on 7/2/21.
//  Copyright © 2021 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class UserBooksTableViewController: UITableViewController {
    
//    var itemDOI: String?
    
    var doiArr = [String]()
    
    var titleArr =  [String]()
    
    var authorArr = [String]()
    
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
    
    var subjectsName: String?
    
    let networkManager = NetworkManager()

    var ref: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.workTitle.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let url = URL(string: "https://api.crossref.org/works?query=\(subjectsName!)")

        NetworkManager().getDataFromAPI(url: url!, successHandler: { (data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                let jsonDic = json as! [String: Any]
                let work = jsonDic["message"] as! [String: Any]
                let items = work["items"] as! [Any]
                for item in items {
                    // get title, author, publisher
                    let itemDic = item as! [String: Any]
                    let title = itemDic["title"] as! [Any]
                    self.workTitle.append("\(title.first ?? " ")")
                    let doi = itemDic["DOI"] as! String
                    print(doi)
                    self.workDOI.append("\(doi)")
                    if let author = itemDic["author"] as? [Any], let authorDic = author.first as? [String: Any] {

                        let authorName = "\(authorDic["given"] ?? " ")" + " " + "\(authorDic["family"] ?? " ")"
                        self.author.append(authorName)
                    } else {
                        self.author.append("No Author Was Found")
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("table view reload data")
                }
            } catch {
                print(error)
            }
        }) { (error) in
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Favorites") { (action, view, completionHandler) in
            // save in database
            let thisDOI = self.workDOI[indexPath.row]
            let thisTitle = self.workTitle[indexPath.row]
            let thisAuthor = self.author[indexPath.row]
//            print(thisDOI)
            self.doiArr.append(thisDOI)
            self.titleArr.append(thisTitle)
            self.authorArr.append(thisAuthor)
//            print(self.titleArr)
//            print(self.authorArr)
            let user = Auth.auth().currentUser
            let refData = self.ref?.child("Users").child(user!.uid).child("Titles")
//            print(self.doiArr)
            refData?.setValue(self.titleArr, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("we got data")
                }
            })
            let refAuthorData = self.ref?.child("Users").child(user!.uid).child("Authors")
            refAuthorData?.setValue(self.authorArr, withCompletionBlock: { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("we got author's data")
                }
            })
            print("favorites ------------------------------------------------")
            completionHandler(true)
        }
        action.backgroundColor = .systemBlue
        action.image = UIImage(systemName: "star")
        action.title = "Favorite"
        return UISwipeActionsConfiguration(actions: [action])
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userBookCell", for: indexPath)
        
        if self.workTitle.count == self.author.count {
            cell.textLabel?.text = self.workTitle[indexPath.row]
            cell.detailTextLabel?.text = self.author[indexPath.row]
        } else {
            print(self.workTitle.count, self.author.count)
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
