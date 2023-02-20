//
//  ReviewTableViewCell.swift
//  RemoveThis2
//
//  Created by Dastan on 9/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var customerName: UITextField!
    @IBOutlet weak var customerReview: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
        customerNameSetup()
        customerReviewSetup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup() {
        layer.cornerRadius = 6
        layer.borderWidth = 1
        clipsToBounds = true
//        viewTable.backgroundColor = .systemGreen
        
    }
    
    func customerNameSetup() {
        customerName.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    }
    
    func customerReviewSetup() {
        customerReview.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    func initialSetup(article: CustomerReview) {
        if let nickName = article.attributes?.reviewerNickname {
            customerName.text = nickName
        }
        if let title = article.attributes?.title {
            customerReview.text = title
        }
    }
}
