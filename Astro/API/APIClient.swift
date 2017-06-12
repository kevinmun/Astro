//
//  APIClient.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol IAPIClient {
    func requestChannelList() -> Observable<ChannelListModel>
}

class APIClient: IAPIClient {
    let baseUrl: String = "http://ams-api.astro.com.my"
    
    func requestChannelList() -> Observable<ChannelListModel> {
        let request = Observable<ChannelListModel>.create { [unowned self] (observer) -> Disposable in
            let requestRef = Alamofire.request(self.baseUrl + "/ams/v3/getChannelList").responseJSON { response in
                if let json = response.result.value {
                    let channelListModel = ChannelListModel(data: json as! [String : Any])
                    observer.onNext(channelListModel)
                    observer.onCompleted()
                } else if let error = response.result.error {
                    observer.onError(error)
                }
            }
            return Disposables.create(with: { requestRef.cancel() })
        }
        return request
    }
}
