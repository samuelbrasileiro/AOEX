//
//  ProdutoresTableViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

var userProdutor: Produtor?

class ProdutorsViewController: UIViewController, ProdutorCellDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var produtores: [Produtor] = []
    
    let statesBank = StatesBrazil()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        view.addSubview(UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 82)))
        
        navigationController?.navigationBar.isHidden = true
        
        let bc = UIImageView(frame: view.frame)
        bc.contentMode = .scaleAspectFill
        bc.image = UIImage(named: "background")
        bc.backgroundColor = UIColor(red: 0xF3/0xFF, green: 0xF3/0xFF, blue: 0xF3/0xFF, alpha: 1)
        self.view.addSubview(bc)
        self.view.sendSubviewToBack(bc)
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        
        
        self.observeChilds()
        
        
    }
    
    func observeChilds(){
        //outros users
        let ref = Database.database().reference().child("users").queryOrdered(byChild: "state")
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            //print(snapshot)
            let produtor = Produtor(snapshot: snapshot)
            produtor.image = UIImage(named: "default-user")
            if userProdutor!.uid != produtor.uid && !self.produtores.contains(where: {produtor.uid == $0.uid}){
                DispatchQueue.global(qos: .background).async {
                    
                    
                    if produtor.imageURL != nil{
                        
                        
                        let url = NSURL(string: produtor.imageURL!)
                        let data = NSData(contentsOf: url! as URL)
                        if data != nil {
                            produtor.image = UIImage(data: data! as Data)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                
                            }
                        }
                    }
                }
                self.produtores.append(produtor)
                self.produtores.sort{ userProdutor!.distance(from: $0) < userProdutor!.distance(from: $1)}
                
                
                
                let index = self.produtores.firstIndex{$0 === produtor}
                self.tableView.insertRows(at: [IndexPath(row: index!, section: 0)], with: UITableView.RowAnimation.automatic)
            }
            
        }, withCancel: nil)
        
        //ver mudanças
        ref.observe(.childChanged, with: { (snapshot) -> Void in
            let produtor = Produtor(snapshot: snapshot)
            if let index = self.produtores.firstIndex(where: {produtor.uid == $0.uid}){
                self.produtores[index] = produtor
                self.tableView.reloadData()
            }
            
        },withCancel: nil)
        
        
    }
    func knowMoreButtonTapped(cell: ProdutorTableViewCell) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "produtorView") as! ProdutorViewController
        vc.produtor = produtores[indexPath!.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return produtores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 147.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "produtorCell", for: indexPath) as? ProdutorTableViewCell else {fatalError("The dequeued cell is not an instance of ProdutorTableViewCell.")}
        cell.delegate = self
        cell.addSeparator(at: .right, color: .lightGray)
        cell.backgroundColor = .clear
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackgroundView
        
        
        if let image = produtores[indexPath.row].image{
            cell.userImage.image = image
        }
        if let name = produtores[indexPath.row].name, let product = produtores[indexPath.row].product, let place = produtores[indexPath.row].state?.name{
            cell.name.text = name
            cell.product.text = product
            cell.placeLabel.text = place
            
        } else{
            cell.name.text = "Inválido"
            cell.product.text = "Sem produto definido"
        }
        
        
        return cell
    }
    
    
}
