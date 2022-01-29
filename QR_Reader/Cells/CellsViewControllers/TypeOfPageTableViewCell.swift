//
//  PageTypeTableViewCell.swift
//  QR_Reader
//
//  Created by MacBook Air on 30.01.2022.
//

import UIKit

class TypeOfPageTableViewCell: UITableViewCell {

    @IBOutlet weak var typeOfPageName: UILabel!
    @IBOutlet weak var typeOfPageImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
