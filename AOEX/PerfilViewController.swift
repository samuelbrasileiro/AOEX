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
    
    let scrollView = UIScrollView()
    
    let inicialHeight = 50
    
    let solicitationTableView = UITableView()
    
    var solicitators: [Produtor] = []
    
    var solicitatorsButton = UIButton()
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        
        super.viewDidLoad()
        scrollView.frame = self.view.frame
        scrollView.frame.size.height -= self.tabBarController?.tabBar.frame.height ?? 83
        
        
        image.frame = CGRect(x: 131, y: 145, width: 152, height: 152)
        image.image = UIImage(named: "default-user")
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.height/2
        if userProdutor!.image == nil{
            DispatchQueue.global(qos: .background).async {
                
                if let imageURL = userProdutor!.imageURL{
                    
                    
                    let url = NSURL(string: imageURL)
                    let data = NSData(contentsOf: url! as URL)
                    if data != nil {
                        print("haha")
                        userProdutor!.image = UIImage(data: data! as Data)
                        DispatchQueue.main.async {
                            self.image.image = userProdutor!.image
                        }
                    }
                }
            }
        }
        
        let menuLabel = UILabel(frame: CGRect(x: 83, y: 56, width: 248, height: 62))
        menuLabel.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        menuLabel.font = menuLabel.font.withSize(50)
        menuLabel.text = "Menu"
        menuLabel.textAlignment = .center
        
        
        let greetingsLabel = UILabel(frame: CGRect(x: 20, y: 300, width: scrollView.frame.size.width - 40, height: 200))
        greetingsLabel.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        greetingsLabel.numberOfLines = 3
        greetingsLabel.font = menuLabel.font.withSize(50)
        greetingsLabel.backgroundColor = .systemBlue
        greetingsLabel.text = "Olá, " + userProdutor!.name! + "!"
        greetingsLabel.textAlignment = .center
        
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(solicitationsControl)
        scrollView.addSubview(image)
        scrollView.addSubview(greetingsLabel)
        
        view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentSize = scrollView.frame.size
        
        configureControl()
    }
    func configureControl(){
        solicitationsControl.frame = CGRect(x: 20, y: 557, width: self.scrollView.frame.width - 40, height: 50)
        solicitatorsButton.addTarget(self, action: #selector(solicitationsButtonAction), for: .touchUpInside)
        solicitationsControl.layer.masksToBounds = true
        solicitationsControl.layer.cornerRadius = 10
        solicitationsControl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        solicitatorsButton.frame = CGRect(x: 5, y: 10, width: 300, height: 30)
        solicitatorsButton.setTitleColor(#colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1), for: .normal)
        solicitatorsButton.setTitle("Ver solicitações pendentes (\(userProdutor!.solicitations.count))", for: .normal)
        solicitationsControl.addSubview(solicitatorsButton)
        
        
        solicitationTableView.frame = CGRect(x: 0, y: 50, width: self.solicitationsControl.frame.size.width, height: CGFloat(userProdutor!.solicitations.count)*80)
        solicitationTableView.register(SolicitationTableViewCell.self, forCellReuseIdentifier: "solicitationCell")
        
        solicitationTableView.delegate = self
        solicitationTableView.dataSource = self
        
        solicitationTableView.backgroundColor = .clear
        solicitationsControl.addSubview(solicitationTableView)
        
        for uid in userProdutor!.solicitations{
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.observe(.value, with: { (snapshot) -> Void in
                
                let produtor = Produtor(snapshot: snapshot)
                
                self.solicitators.append(produtor)
                self.solicitationTableView.reloadData()
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
        
        
        
    }
    
    
    @objc func solicitationsButtonAction(){
        
        if solicitationsControl.frame.size.height == 50{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.solicitationsControl.frame.size.height += self.solicitationTableView.frame.height
            }, completion: nil)
        }
        else{
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.solicitationsControl.frame.size.height = 50
            }, completion: nil)
        }
        
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        
        
        
    }
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
    
    
    
}

extension PerfilViewController: UITableViewDelegate, UITableViewDataSource, removeSolicitatorDelegate{
    func removeSolicitator(solicitator: String) {
        if let index = solicitators.firstIndex(where: {$0.uid == solicitator}){
            
            self.solicitators.remove(at: index)
            solicitatorsButton.setTitle("Ver solicitações pendentes (\(solicitators.count))", for: .normal)
            self.solicitationTableView.reloadData()
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
                self.solicitationsControl.frame.size.height -= 80
            })
        }
        if let index = userProdutor!.solicitations.firstIndex(where: {$0 == solicitator}){
            
            userProdutor!.solicitations.remove(at: index)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == solicitationTableView{
            return solicitators.count
        }
        else {
            return 0
            
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
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == solicitationTableView{
            return 80
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == solicitationTableView{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "solicitationCell", for: indexPath) as? SolicitationTableViewCell else {fatalError("The dequeued cell is not an instance of SolicitationTableViewCell.")}
            let solicitator = solicitators[indexPath.row]
            
            cell.name.text = solicitator.name
            cell.userImage.image = solicitator.image
            cell.backgroundColor = .clear
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedBackgroundView
            return cell
        }
        else{
            return UITableViewCell()
        }
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
        
        addSubview(userImage)
        addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}