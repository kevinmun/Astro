//
//  ChannelsStore.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

protocol IChannelsStore {
    func requestChannelList() -> Observable<ChannelListModel>
    func isFavoriteById(channelId : Int) -> Bool
    func setFavoriteById(channelId: Int)
    func removeFavoriteById(channelId: Int)
}

class ChannelsStore : IChannelsStore {
    let apiClient: IAPIClient
    let userDefaults = UserDefaults.standard
    
    init(apiClient: IAPIClient) {
        self.apiClient = apiClient
    }
    
    func requestChannelList() -> Observable<ChannelListModel> {
        return apiClient.requestChannelList();
    }
    
    func isFavoriteById(channelId: Int) -> Bool {
        if let favoriteIds = userDefaults.array(forKey: "FavoriteChannels") as? [Int] {
            if favoriteIds.contains(channelId) {
                return true
            }
        }
        return false
    }
    
    func setFavoriteById(channelId: Int) {
        if var favoriteIds = userDefaults.array(forKey: "FavoriteChannels") as? [Int] {
            favoriteIds.append(channelId)
            userDefaults.set(favoriteIds, forKey: "FavoriteChannels")
        } else {
            userDefaults.set([channelId], forKey: "FavoriteChannels")
        }
    }
    
    func removeFavoriteById(channelId: Int) {
        if var favoriteIds = userDefaults.array(forKey: "FavoriteChannels") as? [Int] {
            if let index = favoriteIds.index(of: channelId) {
                favoriteIds.remove(at: index)
            }
            userDefaults.set(favoriteIds, forKey: "FavoriteChannels")
        }
    }
}
