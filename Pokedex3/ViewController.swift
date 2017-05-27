//
//  ViewController.swift
//  Pokedex3
//
//  Created by Hussein Ghoniam on 20/04/2017.
//  Copyright © 2017 Hussein Ghoniam. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]() //non-filtered array of pokemons
    var filteredPokemon = [Pokemon]() //filtered array of pokemons from search
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done  //changes the keyboard return button to "done" instead of "search"
        
        parsePokemonCSV()
        initAudio()
    }
    
    //function that gets any of your audio ready
    func initAudio(){
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 //loops infintely
            musicPlayer.play()
            
            
            
        }catch let err as NSError {
            print(err.debugDescription)
        }
        
    }
    
    
    
    
    //parsing the pokemon.csv file
    func parsePokemonCSV() {
        //getting the path to the pokemon.csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            let csv = try CSV(contentsOfURL: path) //assigning csv file to CSV function via url:path
            let rows = csv.rows
            print(rows)
            
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemons.append(poke)
            }
            
        } catch let err as NSError {
                print(err.debugDescription)
        }
    }
    

    // need to add functions:
    // cellforitemAt, didselectitemAt, numberOfItemsInSection, numberofSections, sizeforitemAt
    
    //setting each cell i.e. populating cells with pokemon data via csv function described above
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //5 mins into lecture 90 explains this dequeReusableCell very well.
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(poke)
            } else {
               poke = pokemons[indexPath.row]
                cell.configureCell(poke)
            }
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    //when you tap on a cell, the code inside will execute
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        view.endEditing(true) //removes the keyboard from the screen
        var poke: Pokemon!
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        }else {
            poke = pokemons[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
        
    }

    //sets the number of items in the section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        } else {
        return pokemons.count
        }
    }
    
    //number of sections in the collection view
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //sets size of cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2 //user sender, as it specifies the button thats on the view
        } else {
            musicPlayer.play()
            sender.alpha = 1
        }
    }
    
    // removes the keyboard when search button in search be is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)    // removes the keyboard
        } else {
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased() //set input text to lowercase
            
            filteredPokemon = pokemons.filter({$0.name.range(of:lower) != nil})
            collection.reloadData()
        }
    }
    
    //setup before seque occurs, it is used to pass data between VCs
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
}



