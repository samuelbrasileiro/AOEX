//
//  BioViewController.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 26/07/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import Firebase

class BioViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    
    var placeholderLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        placeholderLabel = UILabel()
        placeholderLabel.text = "Escreva aqui"
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        textView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !textView.text.isEmpty
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    @IBAction func endButtonAction(_ sender: Any) {
        
        let ref = Database.database().reference().child("users").child(userProdutor!.uid!)
        let bioRef = ref.child("bio")
        
        if let text = textView.text{
            bioRef.setValue(text)
        }
        let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
        self.present(tabController, animated: true)
    }
    
    @IBAction func jumpButtonAction(_ sender: Any) {
        let tabController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainTab")
        self.present(tabController, animated: true)
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
