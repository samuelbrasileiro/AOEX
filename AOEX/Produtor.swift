//
//  User.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Produtor{
    var name: String?
    var uid: String?
    var site: String?
    var cnpj: String?
    var product: String?
    var email: String?
    var city: String?
    var state: State?
    var phone: String?
    var imageURL: String?
    var image: UIImage?
    var solicitations: [String] = []
    var creationDate: String?
    init(uid: String){
        self.uid = uid
        self.imageURL = ""
        self.creationDate = String(describing: Date())
    }
    
    init(snapshot: DataSnapshot){
        
        if let dictionary = snapshot.value as? [String: Any] {
            
            self.uid = dictionary["uid"] as? String ?? ""
            self.name = dictionary["name"] as? String ?? ""
            self.site = dictionary["site"] as? String ?? ""
            self.email = dictionary["email"] as? String ?? ""
            self.cnpj = dictionary["cnpj"] as? String ?? ""
            self.phone = dictionary["phone"] as? String ?? ""
            self.city = dictionary["city"] as? String ?? ""
            let uf = dictionary["state"] as? String ?? ""
            self.state = StatesBrazil().get(by: uf)
            self.product = dictionary["product"] as? String ?? ""
            self.imageURL = dictionary["imageURL"] as? String ?? nil
            self.creationDate = dictionary["creationDate"] as? String ?? ""
            self.solicitations = dictionary["solicitations"] as? [String] ?? []
        }
        
    }
    
    func toData() -> Any? {
        let data: [String:Any] =
            ["uid": uid ?? "",
            "email": self.email ?? "",
            "name": self.name ?? "",
            "cnpj": self.cnpj ?? "",
            "phone": self.phone ?? "",
            "site": self.site ?? "",
            "product": self.product ?? "",
            "city": self.city ?? "",
            "state": self.state!.uf ,
            "imageURL": self.imageURL ?? "",
            "solicitations": solicitations,
            "creationDate": self.creationDate ?? String(describing: Date())]
        return data
    }
    func distance(from produtor: Produtor)->Double{
        return sqrt(pow(Double(state!.coordinates.latitude - produtor.state!.coordinates.latitude), 2)+pow(Double(state!.coordinates.longitude - produtor.state!.coordinates.longitude), 2))
        
    }
}
