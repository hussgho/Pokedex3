//
//  PokeCell.swift
//  Pokedex3
//
//  Created by Hussein Ghoniam on 12/05/2017.
//  Copyright © 2017 Hussein Ghoniam. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    //to change the box outer layer corner
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = CGFloat(1.0)

        
    }
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
    
    
}
