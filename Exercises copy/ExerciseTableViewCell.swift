//
//  ExerciseTableViewCell.swift
//  Exercises
//
//  Created by TBishop on 5/16/17.
//  Copyright © 2017 Chesspiece Consulting. All rights reserved.
//

import UIKit

class ExerciseTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var muscleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
