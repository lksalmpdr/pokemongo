//
//  CoredataPokemon.swift
//  PokemonGO
//
//  Created by Pedro Lucas de Almeida on 13/01/23.
//

import Foundation
import CoreData
import UIKit

class CoredataPokemon {
    
    //recuperar context
    func getContext()-> NSManagedObjectContext {
        let appDelegate  = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func addAllPokemon(){
        
        self.createPokemon(nome: "bellsprout", nomeImagem: "bellsprout", capturado: false)
        
        self.createPokemon(nome: "bullbasur", nomeImagem: "", capturado: false)
        
        self.createPokemon(nome: "caterpie", nomeImagem: "caterpie", capturado: false)
        
        self.createPokemon(nome: "charmander", nomeImagem: "charmander", capturado: false)
        
        self.createPokemon(nome: "meowth", nomeImagem: "meowth", capturado: false)
        
        self.createPokemon(nome: "mew", nomeImagem: "mew", capturado: false)
        
        self.createPokemon(nome: "pikachu", nomeImagem: "pikachu-2", capturado: true)
        
        self.createPokemon(nome: "psyduck", nomeImagem: "psyduck", capturado: false)
        
        self.createPokemon(nome: "rattata", nomeImagem: "rattata", capturado: false)
        
        self.createPokemon(nome: "snorlax", nomeImagem: "snorlax", capturado: false)
        
        self.createPokemon(nome: "squirtle", nomeImagem: "squirtle", capturado: false)
        
        self.createPokemon(nome: "zubat", nomeImagem: "zubat", capturado: false)
        
        let context = self.getContext()
        
        do{
            try context.save()
        }catch{
            
        }
    }
    
    func createPokemon(nome:String, nomeImagem:String, capturado:Bool){
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
    }
    
    func getAllPokemon()->[Pokemon]{
        let context = self.getContext()
        do{
            let pokemons = try context.fetch( Pokemon.fetchRequest() ) as! [Pokemon]
            
            if pokemons.count == 0 {
                self.addAllPokemon()
                
                return self.getAllPokemon()
            }
            return pokemons
        }catch{}
        return []
    }
    
    func getAllCaptured(capturado:Bool)->[Pokemon]{
        let context = self.getContext()
        let request = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
        request.predicate = NSPredicate(format: "capturado == %@", NSNumber(value: capturado) )
        
        do {
            let pokemons = try context.fetch(request) as [Pokemon]
            return pokemons
        }catch{
            
        }
        return []
    }
}
