//
//  BluetoothCell.swift
//  BLELists
//
//  Created by Sachin Patoliya on 18/06/22.
//

import UIKit

class BluetoothCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var RSSIidLabel: UILabel!
    
    var cellViewModel: BluetoothListModel? {
        didSet {
            nameLabel.text = cellViewModel?.name == "" ? String(cellViewModel?.UUID.prefix(5) ?? "") : cellViewModel?.name ?? ""
            RSSIidLabel.text = cellViewModel?.RSSIId.stringValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        RSSIidLabel.text = nil
        nameLabel.text = nil
    }
}
