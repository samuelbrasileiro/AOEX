//
//  PerfilViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 21/07/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class PerfilViewController: UIViewController {
    
    let image = UIImageView()
    
    let solicitationsControl = UIControl()
    
    let connectionsControl = UIControl()
    
    let scrollView = UIScrollView()
    
    let inicialHeight = 50
    
    let solicitationTableView = UITableView()
    
    let connectionTableView = UITableView()
    
    var solicitators: [Produtor] = []
    
    var connections: [Produtor] = []
    
    let solicitatorsButton = UIButton()
    
    let connectionsButton = UIButton()
    
    var removedChild: String?
    override func viewDidLoad() {
        //navigationController?.navigationBar.isHidden = true
        
        super.viewDidLoad()
        scrollView.frame = self.view.frame
        scrollView.frame.size.height -= self.tabBarController?.tabBar.frame.height ?? 83
        
        
        image.frame = CGRect(x: 131, y: 145, width: 152, height: 152)
        image.image = UIImage(named: "default-user")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.height/2
        image.contentMode = .scaleAspectFill
        
        if userProdutor!.image == nil{
            DispatchQueue.global(qos: .background).async {
                
                if let imageURL = userProdutor!.imageURL{
                    
                    
                    let url = NSURL(string: imageURL)
                    let data = NSData(contentsOf: url! as URL)
                    if data != nil {
                        
                        userProdutor!.image = UIImage(data: data! as Data)
                        DispatchQueue.main.async {
                            self.image.image = userProdutor!.image
                        }
                    }
                }
            }
        }
        
        //        let menuLabel = UILabel(frame: CGRect(x: 83, y: 56, width: 248, height: 62))
        //        menuLabel.textColor = .systemGray
        //        menuLabel.font = menuLabel.font.withSize(50)
        //        menuLabel.text = "Menu"
        //        menuLabel.textAlignment = .center
        
        
        let greetingsLabel = UILabel(frame: CGRect(x: 20, y: 300, width: scrollView.frame.size.width - 40, height: 200))
        greetingsLabel.textColor = .systemGray
        greetingsLabel.numberOfLines = 3
        greetingsLabel.font = greetingsLabel.font.withSize(50)
        
        greetingsLabel.text = "Olá, " + userProdutor!.name! + "!"
        greetingsLabel.textAlignment = .center
        greetingsLabel.adjustsFontSizeToFitWidth = true
        
        //scrollView.addSubview(menuLabel)
        scrollView.addSubview(solicitationsControl)
        scrollView.addSubview(image)
        scrollView.addSubview(greetingsLabel)
        scrollView.addSubview(connectionsControl)
        
        view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentSize = scrollView.frame.size
        
        configureControl()
        
        configureConnections()
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
    }
    
    func configureControl(){
        solicitationsControl.frame = CGRect(x: 20, y: 557, width: self.scrollView.frame.width - 40, height: 50)
        
        solicitatorsButton.addTarget(self, action: #selector(solicitationsButtonAction), for: .touchUpInside)
        solicitationsControl.layer.masksToBounds = true
        solicitationsControl.layer.cornerRadius = 10
        solicitationsControl.backgroundColor = .systemGray3
        
        solicitatorsButton.frame = CGRect(x: 5, y: 10, width: 300, height: 30)
        solicitatorsButton.setTitleColor(.systemGray, for: .normal)
        solicitatorsButton.setTitle("Ver solicitações pendentes (\(userProdutor!.solicitations.count))", for: .normal)
        solicitationsControl.addSubview(solicitatorsButton)
        
        
        solicitationTableView.frame = CGRect(x: 0, y: 50, width: self.solicitationsControl.frame.size.width, height: CGFloat(userProdutor!.solicitations.count)*80)
        solicitationTableView.register(SolicitationTableViewCell.self, forCellReuseIdentifier: "solicitationCell")
        self.solicitationTableView.separatorStyle = .singleLine
        
        solicitationTableView.delegate = self
        solicitationTableView.dataSource = self
        
        solicitationTableView.backgroundColor = .clear
        solicitationsControl.addSubview(solicitationTableView)
        
        let ref = Database.database().reference().child("users").child(userProdutor!.uid!).child("solicitations")
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            
            if let uid = snapshot.value as? String{
                let ref = Database.database().reference().child("users").child(uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                    let produtor = Produtor(snapshot: snapshot)
                    self.solicitators.append(produtor)
                    self.solicitationTableView.frame.size.height = CGFloat(self.solicitators.count*80)
                    self.solicitatorsButton.setTitle("Ver solicitações pendentes (\(self.solicitators.count))", for: .normal)
                    if self.solicitationsControl.frame.size.height > 50{
                        self.solicitationsControl.frame.size.height += 80
                    }
                    self.solicitationTableView.reloadData()
                    
                    let contentRect: CGRect = self.scrollView.subviews.reduce(into: .zero) { rect, view in
                        rect = rect.union(view.frame)
                    }
                    self.scrollView.contentSize.height = contentRect.height + 10
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        
                        if produtor.imageURL != nil{
                            
                            
                            let url = NSURL(string: produtor.imageURL!)
                            let data = NSData(contentsOf: url! as URL)
                            if data != nil {
                                produtor.image = UIImage(data: data! as Data)
                                
                                DispatchQueue.main.async {
                                    self.solicitationTableView.reloadData()
                                    
                                }
                            }
                        }
                    }
                })
            }
            
        })
        
        ref.observe(.childRemoved, with: { (snapshot) -> Void in
            if let uid = self.removedChild{
                if let index = self.solicitators.firstIndex(where: {$0.uid == uid}){
                    
                    self.solicitators.remove(at: index)
                    self.solicitatorsButton.setTitle("Ver solicitações pendentes (\(self.solicitators.count))", for: .normal)
                    self.solicitationTableView.reloadData()
                    self.solicitationTableView.frame.size.height -= 80
                    if(self.solicitationsControl.frame.size.height > 50){
                        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                            
                            self.solicitationsControl.frame.size.height -= 80
                            self.connectionsControl.frame.origin.y = self.solicitationsControl.frame.maxY + 30
                            
                        })
                    }
                }
                if let index = userProdutor!.solicitations.firstIndex(where: {$0 == uid}){
                    
                    userProdutor!.solicitations.remove(at: index)
                }
            }
        })
        
        
        
    }
    func configureConnections(){
        connectionsControl.frame = CGRect(x: 20, y: self.solicitationsControl.frame.maxY + 30, width: self.scrollView.frame.width - 40, height: 50)
        
        
        connectionsButton.addTarget(self, action: #selector(connectionsButtonAction), for: .touchUpInside)
        connectionsControl.layer.masksToBounds = true
        connectionsControl.layer.cornerRadius = 10
        connectionsControl.backgroundColor = .systemGray3
        
        connectionsButton.frame = CGRect(x: 5, y: 10, width: 330, height: 30)
        connectionsButton.setTitleColor(.systemGray, for: .normal)
        connectionsButton.setTitle("Ver solicitações aprovadas por você (\(connections.count))", for: .normal)
        connectionsControl.addSubview(connectionsButton)
        
        
        
        connectionTableView.frame = CGRect(x: 0, y: 50, width: self.connectionsControl.frame.size.width, height: CGFloat(connections.count*80))
        connectionTableView.register(SolicitationTableViewCell.self, forCellReuseIdentifier: "solicitationCell")
        
        connectionTableView.delegate = self
        connectionTableView.dataSource = self
        connectionTableView.separatorStyle = .singleLine
        
        connectionTableView.backgroundColor = .clear
        connectionsControl.addSubview(connectionTableView)
        
        let ref = Database.database().reference().child("users").child(userProdutor!.uid!).child("connections")
        
        ref.observe(.childAdded, with: { (snapshot) -> Void in
            
            if let uid = snapshot.value as? String {
                
                let ref = Database.database().reference().child("users").child(uid)
                ref.observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                    let produtor = Produtor(snapshot: snapshot)
                    self.connections.append(produtor)
                    self.connectionTableView.frame.size.height = CGFloat(self.connections.count*80)
                    self.connectionsButton.setTitle("Ver solicitações aprovadas por você (\(self.connections.count))", for: .normal)
                    if self.connectionsControl.frame.size.height > 50{
                        self.connectionsControl.frame.size.height += 80
                    }
                    self.connectionTableView.reloadData()
                    
                    let contentRect: CGRect = self.scrollView.subviews.reduce(into: .zero) { rect, view in
                        rect = rect.union(view.frame)
                    }
                    self.scrollView.contentSize.height = contentRect.height + 10
                    
                    DispatchQueue.global(qos: .background).async {
                        
                        
                        if produtor.imageURL != nil{
                            
                            
                            let url = NSURL(string: produtor.imageURL!)
                            let data = NSData(contentsOf: url! as URL)
                            if data != nil {
                                produtor.image = UIImage(data: data! as Data)
                                
                                DispatchQueue.main.async {
                                    self.connectionTableView.reloadData()
                                    
                                }
                            }
                        }
                    }
                    
                })
                
                
                
                
            }
            
        })
        
        
        
        
    }
    
    @objc func solicitationsButtonAction(){
        
        if solicitationsControl.frame.size.height == 50{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.solicitationsControl.frame.size.height += self.solicitationTableView.frame.height
                
                self.connectionsControl.frame.origin.y = self.solicitationsControl.frame.maxY + 30
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.solicitationsControl.frame.size.height = 50
                
                self.connectionsControl.frame.origin.y = self.solicitationsControl.frame.maxY + 30
            }, completion: nil)
        }
        
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        //scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        
        
        
    }
    
    @objc func connectionsButtonAction(){
        
        if connectionsControl.frame.size.height == 50{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.connectionsControl.frame.size.height += self.connectionTableView.frame.height
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.connectionsControl.frame.size.height = 50
            }, completion: nil)
        }
        
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        //scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        
        
        
    }
    
    
    
}

extension PerfilViewController: UITableViewDelegate, UITableViewDataSource, removeSolicitatorDelegate{
    func removeSolicitator(solicitator: String) {
        removedChild = solicitator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == solicitationTableView{
            return solicitators.count
        }
        else {
            return connections.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == solicitationTableView{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "solicitatorViewController") as! SolicitatorViewController
            vc.produtor = solicitators[indexPath.row]
            vc.removeDelegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "produtorView") as! ProdutorViewController
            vc.produtor = connections[indexPath.row]
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == solicitationTableView{
            return 80
        }
        else{
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var produtor: Produtor
        if tableView == solicitationTableView{
            produtor = solicitators[indexPath.row]
        }
        else{
            produtor = connections[indexPath.row]
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "solicitationCell", for: indexPath) as? SolicitationTableViewCell else {fatalError("The dequeued cell is not an instance of SolicitationTableViewCell.")}
        
        
        cell.name.text = produtor.name
        cell.userImage.image = produtor.image
        cell.backgroundColor = .clear
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .clear
        cell.selectedBackgroundView = selectedBackgroundView
        return cell
        
    }
    
}

class SolicitationTableViewCell: UITableViewCell {
    
    var name = UILabel()
    
    let userImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImage.frame = CGRect(x: 10, y: 10, width: 60, height: 60)
        
        userImage.contentMode = .scaleAspectFill
        userImage.image = UIImage(named: "default-user")
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height/2
        
        name.frame = CGRect(x: 100, y: 20, width: 200, height: 40)
        name.textColor = .systemGray
        addSubview(userImage)
        addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
