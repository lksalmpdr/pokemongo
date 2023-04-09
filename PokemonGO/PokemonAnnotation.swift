//
//  PokemonAnnotation.swift
//  PokemonGO
//
//  Created by Pedro Lucas de Almeida on 16/01/23.
//

import UIKit
import MapKit

class PokemonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var pokemon:Pokemon
    
    init(coordenadas: CLLocationCoordinate2D, pokemon:Pokemon){
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
