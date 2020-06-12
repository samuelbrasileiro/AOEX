//
//  ViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 09/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    var handle: AuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
          // ...
        }
        
    }
    let user = Auth.auth().currentUser
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
    @IBAction func loginButtonAction(_ sender: UIButton) {
        
        let loginManager = FirebaseAuthManager()
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        loginManager.signIn(email: email, pass: password) {[weak self] (success) in
            guard let `self` = self else { return }
            var message: String = ""
            if !success {
                message = "Deu erro :("
                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController,animated: true)
                return
            }
            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
            self.present(tabController, animated: true)
            
        }
    }

}

