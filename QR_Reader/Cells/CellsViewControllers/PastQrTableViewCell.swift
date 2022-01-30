//
//  PastQrTableViewCell.swift
//  QR_Reader
//
//  Created by MacBook Air on 30.01.2022.
//

import UIKit

class PastQrTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pastQrNameLabel: UILabel!
    @IBOutlet weak var pastQrUrl: UILabel!
    @IBOutlet weak var pastQrImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
