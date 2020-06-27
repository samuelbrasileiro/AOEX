//
//  NewAccountViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 10/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase
class NewAccountViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cnpjTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    var selectedState: State?
    
    let statesBank = StatesBrazil()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassword.delegate = self
        nameTextField.delegate = self
        cnpjTextField.delegate = self
        siteTextField.delegate = self
        productTextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissEditing))
        self.view.addGestureRecognizer(gesture)
        
        let statePickerView = UIPickerView()
        statePickerView.delegate = self
        statePickerView.dataSource = self
        stateTextField.inputView = statePickerView
        
        dismissAndClosePickerView()
        
    }
    func dismissAndClosePickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let button = UIBarButtonItem(title: "Feito", style: .done, target: self, action: #selector(self.dismissEditing))
        toolbar.setItems([button], animated: true)
        toolbar.isUserInteractionEnabled = true
        self.stateTextField.inputAccessoryView = toolbar
        
    }
    @objc func dismissEditing(){
        self.view.endEditing(true)
    }
    
    func newAccount(){
        
        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
        { result, error in
            // Create new user in database, not in FIRAuth
            let uid = (Auth.auth().currentUser?.uid)!
            let ref = Database.database().reference().child("users").child(uid)
            
            ref.setValue(["uid": uid, "email": self.emailTextField.text!, "name": self.nameTextField.text!, "cnpj": self.cnpjTextField.text!, "site": self.siteTextField.text ?? "", "product": self.productTextField.text!, "city": self.cityTextField.text!, "state": self.selectedState!.uf, "creationDate": String(describing: Date())]){ (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
            
            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
            self.present(tabController, animated: true)
            
        }
    }
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func validatePassword(candidate: String) -> Bool {
        let passwordRegex =  "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: candidate)
    }
    func validateCNPJ(candidate: String) -> Bool {
        let cnpjRegex = "[0-9]{2}\\.?[0-9]{3}\\.?[0-9]{3}\\/?[0-9]{4}\\-?[0-9]{2}"
        return NSPredicate(format: "SELF MATCHES %@", cnpjRegex).evaluate(with: candidate)
    }
    
    
    func alertar(title: String, message: String,_ completion: (()->Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) -> Void in
            (completion ?? {})()
        }))
        self.present(alertController, animated: true)
        
    }
    
    @IBAction func create(_ sender: Any) {
        //let signUpManager = FirebaseAuthManager()
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            if !validateEmail(candidate: email){
                alertar(title: "Esse e-mail não é válido", message: "Ele tem de ser da forma nome@email.com", nil)
            }
            else if !validatePassword(candidate: password){
                alertar(title: "Sua senha é inválida.",message: "Certifique-se que ela possua os seguintes requisitos:\n\nNo mínimo 8 caracteres\nUma letra maiúscula\n\nUma letra minúscula\n\nDois dígitos", nil)
            }
            else if passwordTextField.text != confirmPassword.text{
                alertar(title: "Você digitou errado",message: "Certifique-se que os campos \"Senha\" e \"Confirmar senha\" sejam iguais", nil)
            }
            else if !validateCNPJ(candidate: cnpjTextField.text ?? ""){
                alertar(title: "Seu CNPJ é inválido", message: "Não precisa ter caracteres.", nil)
            }
            else if nameTextField.text == "" || productTextField.text == "" || cityTextField.text == "" || stateTextField.text == ""{
                alertar(title: "Campos faltando", message: "Preencha todos os campos necessários antes de concluir o cadastro", nil)
            }
            else{
                Auth.auth().createUser(withEmail: email, password: password) { user, error in
                    
                    var message = ""
                    if (error == nil) {
                        message = "Sua conta foi criada"
                        
                        
                    } else {
                        message = "Não foi possível criar sua conta"
                    }
                    self.alertar(title: "Concluído", message: message, {
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

extension NewAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissEditing()
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statesBank.states.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statesBank.get(by: row).name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedState = statesBank.get(by: row)
        self.stateTextField.text = self.selectedState?.name
    }
    
}
