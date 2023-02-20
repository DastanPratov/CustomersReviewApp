//
//  ReviewsVeiwController.swift
//  RemoveThis2
//
//  Created by Dastan on 10/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class ReviewsVeiwController: UIViewController{
    
    private lazy var reviewTableView: UITableView = {
        let r = UITableView()
        r.dataSource = self
        r.delegate = self
        r.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        r.rowHeight = UITableView.automaticDimension
        r.estimatedRowHeight = 300
        r.showsVerticalScrollIndicator = false
        
        return r
    }()
    
    private lazy var reveiwsCount: UILabel = {
        let r = UILabel()
        r.font = UIFont.systemFont(ofSize: 12, weight: .ultraLight)
        r.textAlignment = .center
        r.textColor = .black
        r.backgroundColor = .clear
        r.layer.borderWidth = 1
        r.layer.borderColor = UIColor.systemGray5.cgColor
        r.numberOfLines = 0
        
        return r
    }()
    
    private lazy var addLimitReviewButton: UIBarButtonItem = {
        let a = UIBarButtonItem()
        a.image = UIImage.init(systemName: "plus")
        a.target = self
        a.action = #selector(addLimitButtonTap)
        
        return a
    }()
    
    @objc func addLimitButtonTap() {
        countLimit += 10
        networkManager.limitReview += 10
        networkManager.getApps()
        reveiwsCount.font = UIFont.systemFont(ofSize: 12, weight: .medium)
    }
    
    private lazy var sortedReview: UIBarButtonItem = {
        let s = UIBarButtonItem()
        s.image = UIImage.init(systemName: "arrow.up.arrow.down")
        s.target = self
        s.action = #selector(sortTapped)
        
        return s
    }()
    
    @objc func sortTapped() {
        if sortChange == false {
            networkManager.sortedReview = .createdDate
            networkManager.getApps()
            sortChange.toggle()
            sortDefault.toggle()
        } else if sortChange == true {
            networkManager.sortedReview = .minuscreatedDate
            networkManager.getApps()
            sortChange.toggle()
            sortDefault.toggle()
        }
    }
    
    private var sortChange: Bool = false
    
    private var sortDefault: Bool = true
    
    private var countLimit: Int = 10
    
    private var customerName: [CustomerReview] = []

    private let spaceBetween: CGFloat = 2
    
    private let networkManager = NetworkManager.shared
    
    private var appName: [App] = []
    
    private var appNameNavbar: String
    
    init(appNameNavbar: String, countLimit: Int) {
        self.appNameNavbar = appNameNavbar
        self.countLimit = countLimit
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        constraintsFunc()

        networkManager.networkDelegate = self
        
        networkManager.limitReview = 10
        
        networkManager.sortedReview = .minuscreatedDate
        
        if sortDefault == false {
            networkManager.sortedReview = .createdDate
            networkManager.getApps()
            sortDefault.toggle()
        } else if sortDefault == true {
            networkManager.sortedReview = .minuscreatedDate
            networkManager.getApps()
            sortDefault.toggle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.title = appNameNavbar
        self.navigationItem.setRightBarButtonItems([sortedReview, addLimitReviewButton], animated: true)
        
        networkManager.limitReview = countLimit
        networkManager.getApps()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        sortDefault.toggle()
    }
    
    func constraintsFunc() {
        view.addSubview(reviewTableView)
        view.addSubview(reveiwsCount)
        
        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(2)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
        }
        
        reveiwsCount.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(26)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
    }
}

extension ReviewsVeiwController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerName.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ReviewTableViewCell
        let articleName = customerName[indexPath.section]
        cell.initialSetup(article: articleName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reviewTableView.deselectRow(at: indexPath, animated: false)
        
        let article = customerName[indexPath.section]
        let detailVC = DetailsViewController(article: article)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return spaceBetween
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
}

extension ReviewsVeiwController: NetworkDelegate {
    func getApps(apps: [AppStoreConnect_Swift_SDK.CustomerReview]) {
        print("Reviews Count:", apps.count)
        self.customerName = apps
        DispatchQueue.main.async {
            self.reviewTableView.reloadData()
            
            if apps.count < 200 {
                self.reveiwsCount.text = "Количество комментариев: \(apps.count)"
            } else {
                self.reveiwsCount.text = "Максимально доступное количество комментариев: \(apps.count)"
            }
            
            if apps.count == 0 {
                self.reveiwsCount.text = "Комментарии отсутствуют"
                self.reveiwsCount.font = UIFont.systemFont(ofSize: 20, weight: .light)
                self.reveiwsCount.textColor = .black
                self.reveiwsCount.layer.borderWidth = 0
                self.reveiwsCount.snp.makeConstraints {
                    $0.centerY.equalTo(self.view)
                }
            }
        }
    }
    
    func errorFetch(error: Error) {
        print(error)
    }
    
    func getID(id: String) {
    }
    
    func getAppInfo(apps: [AppStoreConnect_Swift_SDK.App]) {
        self.appName = apps
    }
    
    func getLimitReview(limit: Int) {
        networkManager.limitReview = limit
    }
    
    func getSort(app: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort) {
        networkManager.sortedReview = app
    }
}
