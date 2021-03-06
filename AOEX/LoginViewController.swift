//
//  ViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 09/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase
import Security
import KeychainSwift

class LoginViewController: UIViewController, UITextFieldDelegate {
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in

        }
        
    }
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        let gesture = UITapGestureRecognizer(target: self, action: #selector(end))
        self.view.addGestureRecognizer(gesture)
        
        
        let keychain = KeychainSwift()
        keychain.accessGroup = "1524880673samuel.AOEX"
        if let email = keychain.get("email"),
            let password = keychain.get("password") {
            emailTextField.text = email
            passwordTextField.text = password
        }
        
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == passwordTextField{
            loginButtonAction(loginButton)
            end()
            return true
        }
        else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
            return false
        }
        return false
    }
    
    @objc func end(){
        self.view.endEditing(true)
    }
    
    
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        let loginManager = FirebaseAuthManager()
        
        
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if !success {
                message = "Ocorreu um erro, tente novamente"
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController,animated: true)
                return
            }
            
            
                
            let keychain = KeychainSwift()
            keychain.accessGroup = "1524880673samuel.AOEX"
            keychain.set(email, forKey: "email")
            keychain.set(password, forKey: "password")
            
            let userUID = Auth.auth().currentUser!.uid
            let userRef = Database.database().reference().child("users").child(userUID)
            
            //para pegar o usuario PRINCIPAL/MEUPERFIL
            userRef.observe(.value, with: { (snapshot) -> Void in
                //let produtor = Produtor(snapshot: snapshot)
                
                let produtor = Produtor(snapshot: snapshot)
                userProdutor = produtor
                
                
                
                let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
                self.present(tabController, animated: true)
                
            })
            
            
        }
    }

}

