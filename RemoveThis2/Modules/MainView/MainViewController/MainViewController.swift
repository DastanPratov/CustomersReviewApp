//
//  MainViewController.swift
//  RemoveThis2
//
//  Created by Dastan on 7/2/23.
//

import UIKit
import SnapKit
import AppStoreConnect_Swift_SDK

class MainViewController: UIViewController{

    private lazy var appsTableVeiw: UITableView = {
        let a = UITableView()
        
        a.dataSource = self
        a.delegate = self
        
        a.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        a.rowHeight = UITableView.automaticDimension
        a.estimatedRowHeight = 300
        
        a.showsVerticalScrollIndicator = false
        
        return a
    }()
    
    private lazy var appCount: UILabel = {
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
    
    var appsName: [App] = []
    
    let spaceBetweenTables: CGFloat = 2
    
    var networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        tableSetup()

        networkManager.networkDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.tintColor = .black
        
        networkManager.getAppInfo()
    }
    
    func tableSetup() {
        view.addSubview(appsTableVeiw)
        view.addSubview(appCount)
        
        appsTableVeiw.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-26)
        }
        
        appCount.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(26)
            $0.leading.equalToSuperview().offset(0)
            $0.trailing.equalToSuperview().offset(0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(0)
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return appsName.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = appsTableVeiw.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        let appName = appsName[indexPath.section]
        cell.initialSetup(a: appName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appsTableVeiw.deselectRow(at: indexPath, animated: false)
        let a = appsName[indexPath.section]
        let newVC = ReviewsVeiwController(appNameNavbar: (a.attributes?.name)!, countLimit: 10)
        networkManager.appsID = a.id
        print(a.id)
        navigationController?.pushViewController(newVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return spaceBetweenTables
    }

}

extension MainViewController: NetworkDelegate {
    func getAppInfo(apps: [AppStoreConnect_Swift_SDK.App]) {
        self.appsName = apps
        print("apps count: \(apps.count)")
        DispatchQueue.main.async {
            self.appsTableVeiw.reloadData()
            self.appCount.text = "Количество приложений: \(apps.count)"
        }
    }

    func getID(id: String) {
        networkManager.appsID = id
    }
    
    func getApps(apps: [AppStoreConnect_Swift_SDK.CustomerReview]) {
    }
    
    func errorFetch(error: Error) {
        print(error)
    }
    
    func getLimitReview(limit: Int) {
    }
    
    func getSort(app: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort) {
    }
}
