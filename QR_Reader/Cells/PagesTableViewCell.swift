//
//  PagesTableViewCell.swift
//  QR_Reader
//
//  Created by MacBook Air on 26.01.2022.
//

import UIKit

class PagesTableViewCell: UITableViewCell {

    @IBOutlet weak var cellsDate: UILabel!
    @IBOutlet weak var cellsURL: UILabel!
    @IBOutlet weak var cellsTitle: UILabel!
    @IBOutlet weak var cellsImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellsImageView.image = UIImage(named: "safari")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
