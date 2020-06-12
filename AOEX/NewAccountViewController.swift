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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(end))
        self.view.addGestureRecognizer(gesture)
            
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
        let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            if !validateEmail(candidate: emailTextField.text!){
                alertar(message: "Seu e-mail é inválido.", nil)
            }
            else if !validatePassword(candidate: passwordTextField.text!){
                alertar(message: "Sua senha é inválida.", nil)
            }
            else{
                signUpManager.createUser(email: email, password: password) {[weak self] (success) in
                    guard let `self` = self else { return }
                    var message = ""
                    if (success) {
                        message = "Sua conta foi criada"
                    } else {
                        message = "Não foi possível criar sua conta"
                    }
                    self.alertar(message: message, {
                        if success{
                            print("ADOLETA")
                            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
                            self.present(tabController, animated: true)
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
