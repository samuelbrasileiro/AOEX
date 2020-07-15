//
//  Solicitation.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 14/07/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation

class Solicitation{
    var id: String
    var uidSolicitator: String
    var uidSolicitee: String
    
    enum Status: Int{
        case new
        case accepted
        case refused
    }
    
    var status: Status
    
    init(id: String, uidSolicitator: String, uidSolicitee: String){
        self.id = id
        self.uidSolicitator = uidSolicitator
        self.uidSolicitee = uidSolicitee
        self.status = Status(rawValue: 0)!
    }
    
    
}
