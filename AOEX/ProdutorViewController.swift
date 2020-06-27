//
//  ProdutorViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 26/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit

class ProdutorViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var wantAPL: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    var produtor: Produtor?
    
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
    }
    
    
    @IBAction func contact(_ sender: Any) {
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
