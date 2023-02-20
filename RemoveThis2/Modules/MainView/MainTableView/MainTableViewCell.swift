//
//  MainTableViewCell.swift
//  RemoveThis2
//
//  Created by Dastan on 15/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var appsName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.cornerRadius = 8
        layer.borderWidth = 1
        clipsToBounds = true
        
        appsName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        appsName.textColor = .black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initialSetup(a: App) {
        if let name = a.attributes?.name {
            appsName.text = name
        }
    }
    
}
