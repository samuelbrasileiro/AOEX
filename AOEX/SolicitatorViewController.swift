//
//  SolicitatorViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 21/07/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase
protocol removeSolicitatorDelegate {
    func removeSolicitator(solicitator: String)
}
class SolicitatorViewController: UIViewController {

    var removeDelegate: removeSolicitatorDelegate?
        
    @IBOutlet var userImage: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
    @IBOutlet var bioTextView: UITextView!
    
    var produtor: Produtor?
    
    var solicitation: Solicitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.isHidden = false
//        let backButton = UIBarButtonItem()
//
//        backButton.title = "Voltar"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        guard produtor != nil else{
            fatalError()
        }
        
        titleLabel.text = produtor?.name
        distanceLabel.text = produtor?.state?.name
        productLabel.text = produtor?.product
        placeLabel.text = produtor?.city
        userImage.image = produtor?.image
        websiteLabel.text = produtor?.site ?? ""
        bioTextView.isEditable = false
        let bioRef = Database.database().reference().child("users").child(produtor!.uid!).child("bio")
        bioRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let bio = snapshot.value as? String{
                
                self.bioTextView.text = bio
            }
            else{
                self.bioTextView.text = "O usuário não cadastrou uma bio"
            }
        })
        
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
        userImage.contentMode = .scaleAspectFill
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let index = userProdutor!.solicitations.firstIndex(where: {produtor!.uid! == $0}){
            userProdutor!.solicitations.remove(at: index)
            removeDelegate?.removeSolicitator(solicitator: produtor!.uid!)
            navigationController?.popViewController(animated: true)
            
            let statusRef = Database.database().reference().child("solicitations").child(userProdutor!.uid!).child(produtor!.uid!).child("status")
            if sender == rejectButton{
            statusRef.setValue(String(Solicitation.Status.refused.rawValue))
            }
            else if sender == acceptButton{
                statusRef.setValue(String(Solicitation.Status.accepted.rawValue))
                
                for uid in [userProdutor!.uid!, produtor!.uid!]{
                    let ref = Database.database().reference().child("users").child(uid).child("connections")
                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        
                        if var value = snapshot.value as? [String]{
                            
                            if value.isEmpty {
                                value = []
                            }
                            
                            if uid == userProdutor!.uid!{
                                value.append(self.produtor!.uid!)
                            }
                            else{
                                value.append(userProdutor!.uid!)
                            }
                            
                            ref.setValue(value)
                            
                        }
                        else{
                            var value: [String] = []
                            
                            if uid == userProdutor!.uid!{
                                value.append(self.produtor!.uid!)
                            }
                            else{
                                value.append(userProdutor!.uid!)
                            }
                            
                            ref.setValue(value)
                        }
                    })
                    
                }
                
                
            }
            let solicitationsRef = Database.database().reference().child("users").child(userProdutor!.uid!).child("solicitations")
            solicitationsRef.setValue(userProdutor!.solicitations)
            
            
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //navigationController?.navigationBar.isHidden = true
        
    }
    

}
