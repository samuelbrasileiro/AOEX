//
//  User.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation
import MapKit
class Produtor{
    var name: String?
    var uid: String
    var site: String?
    var cnpj: String?
    var product: String?
    var email: String?
    var city: String?
    var state: State?
    var phone: String?
    init(uid: String){
        self.uid = uid
    }
    func distance(from produtor: Produtor)->Double{
        return sqrt(pow(Double(state!.coordinates.latitude - produtor.state!.coordinates.latitude), 2)+pow(Double(state!.coordinates.longitude - produtor.state!.coordinates.longitude), 2))
        
    }
}
