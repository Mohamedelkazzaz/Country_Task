//
//  CountryCell.swift
//  Country_Task
//
//  Created by Mohamed Elkazzaz on 26/02/2025.
//

import UIKit

class CountryCell: UITableViewCell {
    
    
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var capitalLabel: UILabel!
    
    @IBOutlet weak var pinButton: UIButton!
    var didSelect: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBAction func pinButtonPressed(_ sender: UIButton) {
        didSelect?()
    }
    
}
