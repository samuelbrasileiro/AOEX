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
    
    let control = UIControl()
    
    let scrollView = UIScrollView()
    
    let inicialHeight = 50
    
    let solicitationTableView = UITableView()
    
    var solicitators: [Produtor] = []
    
    var solicitatorsLabel = UILabel()
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
        
        super.viewDidLoad()
        scrollView.frame = self.view.frame
        scrollView.frame.size.height -= self.tabBarController?.tabBar.frame.height ?? 83
        
        
        image.frame = CGRect(x: 131, y: 145, width: 152, height: 152)
        
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.frame.height/2
        
        let menuLabel = UILabel(frame: CGRect(x: 83, y: 56, width: 248, height: 62))
        menuLabel.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        menuLabel.font = menuLabel.font.withSize(50)
        menuLabel.text = "Menu"
        menuLabel.textAlignment = .center
        
        scrollView.addSubview(menuLabel)
        scrollView.addSubview(control)
        scrollView.addSubview(image)
        view.addSubview(scrollView)
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.contentSize = scrollView.frame.size
        
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
        
        control.frame = CGRect(x: 20, y: 557, width: 374, height: 50)
        control.addTarget(self, action: #selector(solicitationsButton), for: .touchUpInside)
        control.layer.masksToBounds = true
        control.layer.cornerRadius = 10
        control.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        solicitatorsLabel.frame = CGRect(x: 5, y: 10, width: 300, height: 30)
        solicitatorsLabel.textColor = #colorLiteral(red: 0.3364960849, green: 0.3365047574, blue: 0.3365000486, alpha: 1)
        solicitatorsLabel.text = "Ver solicitações pendentes (\(userProdutor!.solicitations.count))"
        control.addSubview(solicitatorsLabel)
        
        
        solicitationTableView.frame = CGRect(x: 0, y: 50, width: self.control.frame.size.width, height: CGFloat(userProdutor!.solicitations.count)*80)
        solicitationTableView.register(SolicitationTableViewCell.self, forCellReuseIdentifier: "solicitationCell")
        
        solicitationTableView.delegate = self
        solicitationTableView.dataSource = self
        
        control.addSubview(solicitationTableView)
        
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
    
    
    @objc func solicitationsButton(){
        
        control.removeTarget(nil, action: nil, for: .touchUpInside)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.control.frame.size.height += self.solicitationTableView.frame.height
        }, completion: nil)
        
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.height = contentRect.height + 10
        scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: false)
        
        
        
    }
    
    
}

extension PerfilViewController: UITableViewDelegate, UITableViewDataSource, removeSolicitatorDelegate{
    func removeSolicitator(solicitator: String) {
        if let index = solicitators.firstIndex(where: {$0.uid == solicitator}){
            
            self.solicitators.remove(at: index)
            self.solicitatorsLabel.text = "Ver solicitações pendentes (\(solicitators.count))"
            self.solicitationTableView.reloadData()
            UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.control.frame.size.height -= 80
            })
        }
        if let index = userProdutor!.solicitations.firstIndex(where: {$0 == solicitator}){
        
            userProdutor!.solicitations.remove(at: index)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return solicitators.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "solicitatorViewController") as! SolicitatorViewController
        vc.produtor = solicitators[indexPath.row]
        vc.removeDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "solicitationCell", for: indexPath) as? SolicitationTableViewCell else {fatalError("The dequeued cell is not an instance of SolicitationTableViewCell.")}
        let solicitator = solicitators[indexPath.row]

        cell.name.text = solicitator.name
        cell.userImage.image = solicitator.image
        return cell
    }
    
}

class SolicitationTableViewCell: UITableViewCell {
    
    var name = UILabel()

    let userImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.bounds.midX
        userImage.isHidden = false
        userImage.contentMode = .scaleAspectFill
        
        userImage.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        name.frame = CGRect(x: 100, y: 20, width: 200, height: 60)
        
        addSubview(userImage)
        addSubview(name)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
