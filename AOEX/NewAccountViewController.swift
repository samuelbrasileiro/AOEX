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
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var siteTextField: UITextField!
    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var userImageView: UIImageView!
    
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
        
        let backButton = UIBarButtonItem()
        backButton.title = "Voltar"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = userImageView.bounds.midX
        userImageView.isHidden = true
        userImageView.contentMode = .scaleAspectFill
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
            let produtor = Produtor(uid: uid)
            produtor.name = self.nameTextField.text!
            produtor.site = self.siteTextField.text
            produtor.email = self.emailTextField.text!
            produtor.cnpj = self.cnpjTextField.text!
            produtor.phone = self.phoneTextField.text!
            produtor.city = self.cityTextField.text!
            let uf = self.selectedState!.uf
            produtor.state = self.statesBank.get(by: uf)
            produtor.product = self.productTextField.text!
            
            userProdutor = produtor
            
            ref.setValue(produtor.toData()){ (error, ref) in
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    return
                }
            }
            
            

            
            if let image = self.userImageView.image{
                let data = image.pngData()
                let sRef = Storage.storage().reference()
                let photoRef = sRef.child("photos/" + uid + ".png")
                photoRef.putData(data!, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    print(size)
                    photoRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        userProdutor?.imageURL = downloadURL.absoluteString
                        ref.updateChildValues(["imageURL": downloadURL.absoluteString]){ (error, ref) in
                            if let error = error {
                                assertionFailure(error.localizedDescription)
                                return
                            }
                        }
                        
                    }
                }
            }
            
            
            let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
            self.present(tabController, animated: true)

            
        }
    }
    
    @IBAction func addImageButton(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        let actionSheet = UIAlertController(title: "Escolha uma fonte", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Câmera", style: .default, handler: {(action:UIAlertAction) in
            
            vc.sourceType = .camera
            vc.cameraCaptureMode = .photo
            vc.cameraFlashMode = .off
            self.present(vc, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Biblioteca de Fotos", style: .default, handler: {(action:UIAlertAction) in
            
            vc.sourceType = .photoLibrary
            self.present(vc, animated: true)
        }))
        if userImageView.image != nil{
            actionSheet.addAction(UIAlertAction(title: "Apagar a foto", style: .destructive, handler: {(action:UIAlertAction) in
                self.userImageView.image = nil
                
                
            }))
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true)
        
    }
    
    
    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    func validatePhone(candidate: String) -> Bool {
        let phoneRegex = "(\\(\\d{2}\\))(\\d{4,5}\\-\\d{4})"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: candidate)
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
                alertar(title: "Sua senha é inválida.",message: "Certifique-se que ela possua os seguintes requisitos:\n\nNo mínimo 8 caracteres\nUma letra maiúscula\nUma letra minúscula\nDois dígitos", nil)
            }
            else if passwordTextField.text != confirmPassword.text{
                alertar(title: "Você digitou errado",message: "Certifique-se que os campos \"Senha\" e \"Confirmar senha\" sejam iguais", nil)
            }
            else if !validateCNPJ(candidate: cnpjTextField.text ?? ""){
                alertar(title: "Seu CNPJ é inválido", message: "Não precisa ter caracteres.", nil)
            }
            else if !validatePhone(candidate: phoneTextField.text ?? ""){
                alertar(title: "Seu número de celular é inválido", message: "Coloque da forma (DDD)XXXXX-XXXX.", nil)
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

extension NewAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("Nenhuma imagem encontrada")
            return
        }
        
        userImageView.image = image
        userImageView.isHidden = false
        imageButton.setTitle("Alterar imagem", for: .normal)
    }
    
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
