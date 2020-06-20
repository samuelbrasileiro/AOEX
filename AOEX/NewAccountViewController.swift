//
//  NewAccountViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 10/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase
class NewAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        nameTextField.delegate = self
        siteTextField.delegate = self
        productTextField.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(end))
        self.view.addGestureRecognizer(gesture)
        
    }
    func newAccount(){
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
        { result, error in
            // *3* Create new user in database, not in FIRAuth
            let uid = (Auth.auth().currentUser?.uid)!
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.setValue(["uid": uid, "email": self.emailTextField.text!, "name": self.nameTextField.text!, "site": self.siteTextField.text!, "product": self.productTextField.text!, "creationDate": String(describing: Date())]){ (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
            
            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
            self.present(tabController, animated: true)
            
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        end()
        return true
    }
    @objc func end(){
        self.view.endEditing(true)
    }
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex =  "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    func alertar(message: String,_ completion: (()->Void)?){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) -> Void in
            (completion ?? {})()
        }))
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func create(_ sender: Any) {
        //let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            if !validateEmail(candidate: email){
                alertar(message: "Esse não é um e-mail válido. Ele tem de ser da forma nome@email.com", nil)
            }
            else if !validatePassword(candidate: password){
                alertar(message: "Sua senha é inválida\nCertifíque-se que ela possua no mínimo 8 caracteres, uma letra maiúscula, uma minúscula e dois dígitos", nil)
            }
            else{
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    
                    var message = ""
                    if (error == nil) {
                        message = "Sua conta foi criada"
                        
                        
                    } else {
                        message = "Não foi possível criar sua conta"
                    }
                    self.alertar(message: message, {
                        if error == nil{
                            self.newAccount()
                            
                            
                        }
                    })
                    
                }
                
                
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
