//
//  ContactsCell.swift
//  ContactsFetcher
//
//  Created by Thierry Vilmart on 2022-05-14.
//

import UIKit

class ContactsCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet var fullnameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
