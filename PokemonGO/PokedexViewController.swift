//
//  PokedexViewController.swift
//  PokemonGO
//
//  Created by Pedro Lucas de Almeida on 25/01/23.
//

import UIKit

class PokedexViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let pokemonsCoreData = CoredataPokemon()
    var capturados: [Pokemon] = []
    var naoCapturados: [Pokemon] = []
    var data: [[Pokemon]] = []
    let titulosSessoes: [String] = ["Capturados", "Não Capturados"]
    
    
    @IBOutlet weak var pokemonsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemonsTable.dataSource = self
        pokemonsTable.delegate = self
        
        //self.pokemons = self.pokemonsCoreData.getAllPokemon()
        self.capturados = pokemonsCoreData.getAllCaptured(capturado: true)
        self.naoCapturados = pokemonsCoreData.getAllCaptured(capturado: false)
        
        self.data.append(capturados)
        self.data.append(naoCapturados)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let pokemon  = self.data[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "modelCell", for: indexPath)
        cell.textLabel?.text = pokemon.nome
        cell.imageView?.image = UIImage(named: (pokemon.nomeImagem)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titulosSessoes[section]
    }
    
    @IBAction func voltarMapa(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
