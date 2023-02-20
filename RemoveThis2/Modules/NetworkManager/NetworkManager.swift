//
//  NetworkManager.swift
//  RemoveThis2
//
//  Created by Dastan on 7/2/23.
//

import UIKit
import AppStoreConnect_Swift_SDK

protocol NetworkDelegate{
    func getApps(apps: [AppStoreConnect_Swift_SDK.CustomerReview])
    func getAppInfo(apps: [AppStoreConnect_Swift_SDK.App])
    func errorFetch(error: Error)
    func getID(id: String)
    func getLimitReview(limit: Int)
    func getSort(app: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort)
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    var networkDelegate: NetworkDelegate?
    
    var appsID: String = ""
    
    var sortedReview: APIEndpoint.V1.Apps.WithID.CustomerReviews.GetParameters.Sort?
    
    var limitReview: Int = 1
    
    private let configuration = APIConfiguration(issuerID: "", privateKeyID: "", privateKey: "")
    private lazy var provider: APIProvider = APIProvider(configuration: configuration)
    
    func getApps() {
        let request = APIEndpoint
            .v1
            .apps
            .id(self.appsID)
            .customerReviews
            .get(parameters: .init(
                sort: [ sortedReview! ],
                fieldsCustomerReviews: [ .title, .body, .reviewerNickname, .createdDate, .rating ],
                limit: limitReview
            ))
        
        provider.request(request) { data in
            switch data {
            case .success(let response):
                let result = response.data
                self.networkDelegate?.getApps(apps: result)
            case .failure(_):
                break
            }
            
        }
    }
    
    func getAppInfo() {
        let request = APIEndpoint
            .v1
            .apps
            .get(parameters: .init(
                sort: [ .name ],
                fieldsApps: [ .name, .bundleID ]
            ))
        
        provider.request(request) { data in
            switch data {
            case .success(let response):
                let result = response.data
                self.networkDelegate?.getAppInfo(apps: result)
            case .failure(_):
                break
            }
        }
    }
}
