//
//  PackageTableViewCell.swift
//  finalProject
//
//  Created by Davran Arifzhanov on 16.12.2020.
//

import UIKit

class PackageTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
