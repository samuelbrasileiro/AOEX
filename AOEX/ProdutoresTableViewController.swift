//
//  ProdutoresTableViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class ProdutoresTableViewController: UITableViewController, ProdutorCellDelegate {
    
    var produtores: [Produtor] = []
    
    let statesBank = StatesBrazil()
    var userProdutor: Produtor?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        let bc = UIImageView(frame: tableView.frame)
        bc.contentMode = .scaleAspectFill
        bc.image = UIImage(named: "background")
        bc.backgroundColor = UIColor(red: 0xF3/0xFF, green: 0xF3/0xFF, blue: 0xF3/0xFF, alpha: 1)
        tableView.backgroundView = bc
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        self.clearsSelectionOnViewWillAppear = false
        
        
        
        let userUID = Auth.auth().currentUser!.uid
        let userRef = Database.database().reference().child("users").child(userUID)
        
        
        userRef.observe(.value, with: { (snapshot) -> Void in
            if let dictionary = snapshot.value as? [String: Any] {
                let produtor = Produtor(uid: dictionary["uid"] as! String)
                produtor.name = dictionary["name"] as? String ?? ""
                produtor.site = dictionary["site"] as? String ?? ""
                produtor.email = dictionary["email"] as? String ?? ""
                produtor.cnpj = dictionary["cnpj"] as? String ?? ""
                produtor.phone = dictionary["phone"] as? String ?? ""
                produtor.city = dictionary["city"] as? String ?? ""
                let uf = dictionary["state"] as? String ?? ""
                produtor.state = self.statesBank.get(by: uf)
                produtor.product = dictionary["product"] as? String ?? ""
                self.userProdutor = produtor
            }
            
            self.observeChilds()
            
        })
        
    }
    func observeChilds(){
        let ref = Database.database().reference().child("users").queryOrdered(byChild: "state")
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: Any] {
                let produtor = Produtor(uid: dictionary["uid"] as! String)
                produtor.name = dictionary["name"] as? String ?? ""
                produtor.site = dictionary["site"] as? String ?? ""
                produtor.email = dictionary["email"] as? String ?? ""
                produtor.cnpj = dictionary["cnpj"] as? String ?? ""
                produtor.phone = dictionary["phone"] as? String ?? ""
                produtor.city = dictionary["city"] as? String ?? ""
                let uf = dictionary["state"] as? String ?? ""
                produtor.state = self.statesBank.get(by: uf)
                produtor.product = dictionary["product"] as? String ?? ""
                if self.userProdutor!.uid != produtor.uid{
                self.produtores.append(produtor)
                self.produtores.sort{ self.userProdutor!.distance(from: $0) < self.userProdutor!.distance(from: $1)}
                print(produtor)
                let index = self.produtores.firstIndex{$0 === produtor}
                self.tableView.insertRows(at: [IndexPath(row: index!, section: 0)], with: UITableView.RowAnimation.automatic)
                }
            }
        }, withCancel: nil)
        //        // Listen for deleted comments in the Firebase database
        //        ref.observe(.childRemoved, with: { (snapshot) -> Void in
        //          let index = self.indexOfMessage(snapshot)
        //          self.comments.remove(at: index)
        //          self.tableView.deleteRows(at: [IndexPath(row: index, section: self.kSectionComments)], with: UITableView.RowAnimation.automatic)
        //        })
        
        
        
    }
    func knowMoreButtonTapped(cell: ProdutorTableViewCell) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "produtorView") as! ProdutorViewController
        vc.produtor = produtores[indexPath!.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return produtores.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "produtorCell", for: indexPath) as? ProdutorTableViewCell else {fatalError("The dequeued cell is not an instance of ProdutorTableViewCell.")}
        cell.delegate = self
        cell.addSeparator(at: .right, color: .lightGray)
        cell.backgroundColor = .clear
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackgroundView
        if let name = produtores[indexPath.row].name, let product = produtores[indexPath.row].product, let place = produtores[indexPath.row].state?.name{
            cell.name.text = name
            cell.product.text = product
            cell.placeLabel.text = place
            
        } else{
            cell.name.text = "Inválido"
            cell.product.text = "Sem produto definido"
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "produtorSegue"{
    //
    //            if let _ = segue.destination as? ProdutorViewController {
    //
    //                let selectCell = tableView.indexPathForSelectedRow?.row
    //                let produtor = produtores[selectCell!]
    //                print(produtor.name)
    //
    //            }
    //        }
    //    }
    //
    
}
