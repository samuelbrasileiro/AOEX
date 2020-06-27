//
//  State.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 27/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import Foundation
import MapKit

class State{
    let uf: String
    let name: String
    let coordinates: CLLocationCoordinate2D
    
    init(uf: String, name: String, coordinates: (CLLocationDegrees,CLLocationDegrees)){
        self.uf = uf
        self.name = name
        self.coordinates = CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1)
    }
    
    
}

class StatesBrazil{
    var states: [State] = []
    
    init(){
        states = [
            State(uf: "AC", name: "Acre", coordinates: (-8.77, -70.55)),
            State(uf: "AL", name: "Alagoas", coordinates: (-9.71, -35.73)),
            State(uf: "AM", name: "Amazonas", coordinates: (-3.07, -61.66)),
            State(uf: "AP", name: "Amapá", coordinates: (1.41, -51.77)),
            State(uf: "BA", name: "Bahia", coordinates: (-12.96, -38.51)),
            State(uf: "CE", name: "Ceará", coordinates: (-3.71, -38.54)),
            State(uf: "DF", name: "Distrito Federal", coordinates: (-15.83, -47.86)),
            State(uf: "ES", name: "Espírito Santo", coordinates: (-19.19, -40.34)),
            State(uf: "GO", name: "Goiás", coordinates: (-16.64, -49.31)),
            State(uf: "MA", name: "Maranhão", coordinates: (-2.55, -44.30)),
            State(uf: "MT", name: "Mato Grosso", coordinates: (-12.64, -55.42)),
            State(uf: "MS", name: "Mato Grosso do Sul", coordinates: (-20.51, -54.54)),
            State(uf: "MG", name: "Minas Gerais", coordinates: (-18.10, -44.38)),
            State(uf: "PA", name: "Pará", coordinates: (-5.53, -52.29)),
            State(uf: "PB", name: "Paraíba", coordinates: (-7.06, -35.55)),
            State(uf: "PR", name: "Paraná", coordinates: (-24.89, -51.55)),
            State(uf: "PE", name: "Pernambuco", coordinates: (-8.28, -35.07)),
            State(uf: "PI", name: "Piauí", coordinates: (-8.28, -43.68)),
            State(uf: "RJ", name: "Rio de Janeiro", coordinates: (-22.84, -43.15)),
            State(uf: "RN", name: "Rio Grande do Norte", coordinates: (-5.22, -36.52)),
            State(uf: "RS", name: "Rio Grande do Sul", coordinates: (-30.01, -51.22)),
            State(uf: "RO", name: "Rondônia", coordinates: (-11.22, -62.80)),
            State(uf: "RR", name: "Roraima", coordinates: (1.89, -61.22)),
            State(uf: "SC", name: "Santa Catarina", coordinates: (-27.33, -49.44)),
            State(uf: "SP", name: "São Paulo", coordinates: (-23.55, -46.64)),
            State(uf: "SE", name: "Sergipe", coordinates: (-10.90, -37.07)),
            State(uf: "TO", name: "Tocantins", coordinates: (-10.25, -48.25))
        ]
        
    }
    func get(by uf: String)->State{
        for state in states{
            if uf == state.uf{
                return state
            }
        }
        return State(uf: "--", name: "Não encontrado", coordinates: (0.0,0.0))
    }
    func get(by index: Int)->State{
        return states[index]
    }
    
}
