//
//  ViewController.swift
//  PokemonGO
//
//  Created by Pedro Lucas de Almeida on 19/09/22.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    let locationManager = CLLocationManager()
    
    var coreDataPokemon: CoredataPokemon!
    var pokemons:[Pokemon] = []
    
    //let pokemonsJogaveis: [Pokemon] = []
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.coreDataPokemon = CoredataPokemon()
        self.pokemons = self.coreDataPokemon.getAllPokemon()
        
        
        mapa.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.centralizar()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(gerarPokemon), userInfo: nil, repeats: true)
    }
    
    @objc func gerarPokemon() {
        if let coordenadas = locationManager.location?.coordinate{
            let pokemonSorteado = arc4random_uniform(UInt32(pokemons.count))

            let anotacao = PokemonAnnotation(coordenadas: coordenadas
                                             , pokemon: pokemons[Int(pokemonSorteado)])
            //anotacao.coordinate = coordenadas
            anotacao.coordinate.longitude += geraAleatorio()
            anotacao.coordinate.latitude += geraAleatorio()
            self.mapa.addAnnotation(anotacao)
            
            //remover pokemons periodicamente com um timer aleatório
            let segundosAleatorios = Double(arc4random_uniform(25) + 5) //isso vai garantir que seja executado entre 5 e 30 segundos
            Timer.scheduledTimer(timeInterval: segundosAleatorios, target: self, selector: #selector(apagarAnotacaoPokemon), userInfo: anotacao, repeats: false)

        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation {
            annotationView.image = UIImage(named: "player")
        }else{
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            annotationView.image = UIImage(named: pokemon.nomeImagem!)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation
        
        mapView.deselectAnnotation(annotation, animated: true)
        
        if annotation is MKUserLocation {
            return
        }else{
            let pokemon = (annotation as! PokemonAnnotation).pokemon
            //agora calcular se o pokemon está numa distância aceitavel do jogador
            //uma forma mais simples seria centralizar o mapa no pokemon
            //e testar se o jogador está na área visível do mapa
            //seguindo a seguinte fórmula:
            //if let coordJogador = self.locationManager.location?.coordinate {
                
            //    if self.mapa.visibleMapRect.contains( MKMapPoint(coordJogador))  {
            //        print("pode capturar")
            //    }else{
            //        print("nao pode capturar")
            //    }
            let dist = self.medeDistanciadePontos(self.locationManager.location!.coordinate, annotation!.coordinate)
        
            if (dist <= 0.002){
                
                self.coreDataPokemon.createPokemon(nome: pokemon.nome!, nomeImagem: pokemon.nomeImagem!, capturado: true)
                self.mapa.removeAnnotation(annotation!)
                
                let alertController = UIAlertController(title: "Parabéns!"
                                                        , message: "Você capturou \(pokemon.nome?.uppercased() ?? "")", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(ok)
                
                present(alertController, animated: true, completion: nil)
            
            }else{
                let alertController = UIAlertController(title: "Quase!"
                                                        , message: "Você precisa se aproximar mais do \(pokemon.nome?.uppercased() ?? "")", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(ok)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func geraAleatorio() -> Double {
        let num:Double = (Double( arc4random_uniform(500)) - 250 ) / (100000.0)
        return num
    }
    
    func medeDistanciadePontos(_ coordJogador: CLLocationCoordinate2D, _ coordPokemon:CLLocationCoordinate2D) -> Double{
        let distanciasLatitude = coordJogador.latitude - coordPokemon.latitude
        let distanciasLongitude = coordJogador.longitude - coordPokemon.longitude
        
        let distancia = sqrt( pow(Double(distanciasLatitude), 2) + pow(Double(distanciasLongitude), 2) )
        
        return distancia
    }
    
    @objc func apagarAnotacaoPokemon(sender: Timer){
        let anotacao = sender.userInfo! as! MKAnnotation
        
        self.mapa.removeAnnotation(anotacao)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus != .authorizedWhenInUse &&
            manager.authorizationStatus != .notDetermined {
            //exibir alerta de autorização
            let alertController = UIAlertController(title: "Permissão de Localização", message: "Por favor, habilite", preferredStyle: .alert)
            let configAction = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertaConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenNotificationSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(configAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }

    
    func centralizar(){
        if let coordenadas = self.locationManager.location?.coordinate {
            let regiao = MKCoordinateRegion(center: coordenadas, latitudinalMeters: 200, longitudinalMeters: 200)
            mapa.setRegion(regiao, animated: true)
        }
    }
    
    @IBAction func centralizarJogador(_ sender: Any) {
        self.centralizar()
    }
    
    @IBAction func abrirPokedex(_ sender: Any) {
    }
    
}

