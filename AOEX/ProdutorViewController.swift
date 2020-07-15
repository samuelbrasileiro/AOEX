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
        
        if produtor!.solicitations.contains((userProdutor!.uid)!){
            let ref = Database.database().reference().child("solicitations").child(userProdutor!.uid! + produtor!.uid!)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                print(snapshot.childrenCount)
                
                if let dictionary = snapshot.value as? [String: Any] {
                    let id = dictionary["id"] as? String ?? ""
                    let solicitatorId = dictionary["solicitator"] as? String ?? ""
                    let soliciteeId = dictionary["solicitee"] as? String ?? ""
                    let status = Int(dictionary["status"] as? String ?? "")
                    
                    self.solicitation = Solicitation(id: id, uidSolicitator: solicitatorId, uidSolicitee: soliciteeId)
                    self.solicitation?.status = Solicitation.Status(rawValue: status!)!
                    
                    if self.solicitation!.status == .new{
                        self.titleLabel.text = "BOOOOOM"
                    }
                }
            })
            
            
        }
        else{
            
        }
        
        
    }
    
    
    @IBAction func contact(_ sender: Any) {
        print("huhu")
        print(solicitation)
        if solicitation == nil{
            print("haha")
            let solicitationRef = Database.database().reference().child("solicitations").child(userProdutor!.uid! + produtor!.uid!)
            
            let data = [
                "id": solicitationRef.key,
                "solicitator": userProdutor!.uid,
                "solicitee": produtor!.uid,
                "status": String("0")
            ]
            solicitationRef.setValue(data)
            
            self.solicitation = Solicitation(id: solicitationRef.key!, uidSolicitator: userProdutor!.uid!, uidSolicitee: produtor!.uid!)
            
            let soliciteeRef = Database.database().reference().child("users").child(produtor!.uid!).child("solicitations")
            print("ble")
            soliciteeRef.observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                print(snapshot)
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
        else{
            
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
