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
        
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var wantAPL: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    
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
        
        
        
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        if let index = userProdutor!.solicitations.firstIndex(where: {produtor!.uid! == $0}){
            userProdutor!.solicitations.remove(at: index)
            
            let statusRef = Database.database().reference().child("solicitations").child(userProdutor!.uid!).child(produtor!.uid!).child("status")
            if sender == rejectButton{
            statusRef.setValue(String(Solicitation.Status.refused.rawValue))
            }
            else if sender == acceptButton{
                statusRef.setValue(String(Solicitation.Status.accepted.rawValue))
            }
            let solicitationsRef = Database.database().reference().child("users").child(userProdutor!.uid!).child("solicitations")
            solicitationsRef.setValue(userProdutor!.solicitations)
            
            
        }
        removeDelegate?.removeSolicitator(solicitator: produtor!.uid!)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("aloga")
        print(segue.destination)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
