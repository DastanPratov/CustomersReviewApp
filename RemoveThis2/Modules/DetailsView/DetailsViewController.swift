//
//  DetailsViewController.swift
//  RemoveThis2
//
//  Created by Dastan on 14/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class DetailsViewController: UIViewController {
    
    private lazy var customerNameText: UILabel = {
        let n = UILabel()
        n.font = UIFont.systemFont(ofSize: 14, weight: .light)
        n.numberOfLines = 0
        
        return n
    }()
    
    private lazy var rating: UITextField = {
        let r = UITextField()
        r.textAlignment = .left
        r.text = ""
        r.isEnabled = false
        
        return r
    }()
    
    private lazy var titleReviewText: UILabel = {
        let t = UILabel()
        t.font = UIFont.systemFont(ofSize: 22, weight: .black)
        t.numberOfLines = 0
        return t
    }()
    
    private lazy var detailedReviewText: UILabel = {
        let d = UILabel()
        d.font = UIFont.systemFont(ofSize: 18, weight: .light)
        d.textAlignment = .left
        d.textColor = .black
        d.backgroundColor = .clear
        d.numberOfLines = 0
        
        return d
    }()
    
    private lazy var createdDate: UILabel = {
        let c = UILabel()
        c.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        c.textAlignment = .right
        c.textColor = .systemGray
        c.backgroundColor = .clear
        c.numberOfLines = 0
        
        return c
    }()
    
    private lazy var responeField: UITextField = {
        let r = UITextField()
        r.backgroundColor = .white
        r.textColor = .black
        r.layer.cornerRadius = 8
        r.layer.borderWidth = 1
        r.placeholder = "Reply to customer"
        r.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        r.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        r.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        r.leftViewMode = .always
        r.rightViewMode = .always
        
        r.delegate = self
        
        return r
    }()
    var article: CustomerReview
    
    init(article: CustomerReview) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        setupSubviews()
        setupConstraints()
        setupInitial()
    }
    
    func setupSubviews() {
        view.addSubview(customerNameText)
        view.addSubview(rating)
        view.addSubview(titleReviewText)
        view.addSubview(detailedReviewText)
        view.addSubview(createdDate)
        view.addSubview(responeField)
    }
    
    func setupConstraints() {
        customerNameText.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        rating.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        titleReviewText.snp.makeConstraints {
            $0.top.equalTo(customerNameText.safeAreaLayoutGuide.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        detailedReviewText.snp.makeConstraints {
            $0.top.equalTo(titleReviewText.safeAreaLayoutGuide.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        createdDate.snp.makeConstraints {
            $0.top.equalTo(detailedReviewText.safeAreaLayoutGuide.snp.bottom).offset(14)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        responeField.snp.makeConstraints {
            $0.top.equalTo(createdDate.safeAreaLayoutGuide.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(50)
        }
    }
    
    func setupInitial() {
        customerNameText.text = article.attributes?.reviewerNickname
        titleReviewText.text = article.attributes?.title
        
        if let rate = article.attributes?.rating {
            var cicle = 0
            while cicle < rate {
                rating.text! += "★"
                cicle += 1
            }
            var fullRate = 5 - rate
            
            while fullRate > 0 {
                rating.text! += "☆"
                fullRate -= 1
            }
        }
        
        if let date = article.attributes?.createdDate {
            let dateString = "\(date)"
            let prefixDate = dateString.prefix(10)
            createdDate.text = String(prefixDate)
        }
        detailedReviewText.text = article.attributes?.body
    }
}

extension DetailsViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = responeField.text {
            if text != "" {
                print("Developer responce:", text)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        responeField.resignFirstResponder()
    }
}
