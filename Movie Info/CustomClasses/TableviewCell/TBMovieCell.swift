//
//  TBMovieCell.swift
//  Movie
//
//  Created by Aditya Tanna on 4/26/17.
//  Copyright © 2017 Tanna Inc. All rights reserved.
//

import UIKit

class TBMovieCell: UITableViewCell {

    
    @IBOutlet var imgMovieThumb: UIImageView!
    
    @IBOutlet var lblMovieTitle: UILabel!
    
    @IBOutlet var lblMovieDescription: UILabel!
    
    @IBOutlet var lblMovieCategory: UILabel!
    
    @IBOutlet var lblMovieReleaseDate: UILabel!
    
    @IBOutlet var btnDetails: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
