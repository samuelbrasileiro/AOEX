//
//  ProdutoresTableViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class ProdutoresTableViewController: UITableViewController {
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference().child("users").queryOrdered(byChild: "product")
        
        print(ref)
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
          print(snapshot)
            }, withCancel: nil)
//          self.tableView.insertRows(at: [IndexPath(row: self.users.count-1, section: 0)], with: UITableView.RowAnimation.automatic)
//        })
//        // Listen for deleted comments in the Firebase database
//        ref.observe(.childRemoved, with: { (snapshot) -> Void in
//          let index = self.indexOfMessage(snapshot)
//          self.comments.remove(at: index)
//          self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableView.RowAnimation.automatic)
//        })
        
        self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "produtorCell", for: indexPath)
        
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
