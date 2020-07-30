//
//  ProdutorViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 26/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class ProdutorViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var wantAPL: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var produtor: Produtor?
    
    var solicitation: Solicitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem()
        backButton.title = "Voltar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        guard produtor != nil else{
            fatalError()
        }
        
        titleLabel.text = produtor?.name
        nameLabel.text = produtor?.name
        distanceLabel.text = produtor?.state?.name
        productLabel.text = produtor?.product
        placeLabel.text = produtor?.city
        
        let ref = Database.database().reference().child("users").child(userProdutor!.uid!).child("connections")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let connections = snapshot.value as? [String]{
                if connections.contains(self.produtor!.uid!){
                    self.solicitation = Solicitation(id: "000", uidSolicitator: userProdutor!.uid!, uidSolicitee: self.produtor!.uid!)
                    self.solicitation?.status = .accepted
                    self.button.backgroundColor = .systemGreen
                    self.button.setTitle("Entrar em contato", for: .normal)
                    return
                }
            }
            self.check()
        })
        
        
        
        
    }
    func check(){
        
        let ref = Database.database().reference().child("solicitations").child(produtor!.uid!).child(userProdutor!.uid!)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            if let dictionary = snapshot.value as? [String: Any] {
                let id = dictionary["id"] as? String ?? ""
                let solicitatorId = dictionary["solicitator"] as? String ?? ""
                let soliciteeId = dictionary["solicitee"] as? String ?? ""
                let status = Int(dictionary["status"] as? String ?? "")
                
                self.solicitation = Solicitation(id: id, uidSolicitator: solicitatorId, uidSolicitee: soliciteeId)
                self.solicitation?.status = Solicitation.Status(rawValue: status!)!
                
                if self.solicitation!.status == .new{
                    self.button.backgroundColor = .lightGray
                    self.button.setTitle("Esperando resposta", for: .normal)
                }
                else if self.solicitation!.status == .accepted{
                    self.button.backgroundColor = .systemGreen
                    self.button.setTitle("Entrar em contato", for: .normal)
                }
                else if self.solicitation!.status == .refused{
                    self.button.backgroundColor = .systemRed
                    self.button.setTitle("Seu contato foi rejeitado", for: .normal)
                }
            }
        })
        
    }
    
    @IBAction func contact(_ sender: Any) {
        
        
        if solicitation == nil{
            let solicitationRef = Database.database().reference().child("solicitations").child(produtor!.uid!).child(userProdutor!.uid!)
            
            let data = [
                "id": solicitationRef.key,
                "solicitator": userProdutor!.uid,
                "solicitee": produtor!.uid,
                "status": String(0)
            ]
            solicitationRef.setValue(data)
            
            self.solicitation = Solicitation(id: solicitationRef.key!, uidSolicitator: userProdutor!.uid!, uidSolicitee: produtor!.uid!)
            
            self.button.backgroundColor = .lightGray
            self.button.setTitle("Esperando resposta", for: .normal)
            
            let soliciteeRef = Database.database().reference().child("users").child(produtor!.uid!).child("solicitations")
            soliciteeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if var value = snapshot.value as? [String]{
                    
                    if value.isEmpty || (value.first == "0") {
                        value = []
                    }
                    
                    value.append(userProdutor!.uid!)
                    
                    soliciteeRef.setValue(value)
                }
                else{
                    var value: [String] = []
                    
                    
                    value.append(userProdutor!.uid!)
                    
                    soliciteeRef.setValue(value)
                }
            })
            
        }
        else if solicitation?.status == .accepted{
            
            let phoneNumber =  "+55" + produtor!.phone!.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                }
                else {
                    UIApplication.shared.openURL(appURL)
                }
            } else {
                let alertController = UIAlertController(title: "Erro", message: "Instale o whatsapp para continuar o contato", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
            }
        }
        else if solicitation?.status == .refused{
            
        }
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool){
        super.viewWillDisappear(animated);
        if self.isMovingFromParent{
            navigationController?.navigationBar.isHidden = true
        }
        if self.isMovingToParent{
        }
        if self.isBeingDismissed{
            
        }
    }
    
    
}
