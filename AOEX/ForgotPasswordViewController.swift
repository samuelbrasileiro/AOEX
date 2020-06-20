//
//  ForgotPasswordViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 10/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
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
    

    @IBAction func recoverButton(_ sender: Any) {
        var message = ""
        if validateEmail(candidate: emailTextField.text!){
            Auth.auth().sendPasswordReset(withEmail: emailTextField.text!)
            message = "Se o e-mail for válido, enviaremos um e-mail para resetar a senha desta conta!"
        }
        else{
            message = "Esse não é um e-mail válido. Ele tem de ser da forma nome@email.com"
        }
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true)
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
