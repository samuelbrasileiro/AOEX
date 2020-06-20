//
//  User.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

class Produtor{
    var name: String?
    var uid: String
    var site: String?
    var cnpj: String?
    var product: String?
    var email: String?
    init(uid: String){
        self.uid = uid
    }
}
