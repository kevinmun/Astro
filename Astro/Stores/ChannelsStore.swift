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
    func requestChannelEvents() -> Observable<[ChannelModel]>?
    func isFavoriteById(channelId : Int) -> Bool
    func setFavoriteById(channelId: Int)
    func removeFavoriteById(channelId: Int)
}

class ChannelsStore : IChannelsStore {
    let apiClient: IAPIClient
    let userDefaults = UserDefaults.standard
    var channelListModel: ChannelListModel?
    var page = 0
    
    init(apiClient: IAPIClient) {
        self.apiClient = apiClient
    }
    
    func requestChannelList() -> Observable<ChannelListModel> {
        return apiClient.requestChannelList()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { channelListModel in
                self.channelListModel = channelListModel
                return channelListModel
            }
            .observeOn(MainScheduler.instance)
    }
    
    func requestChannelEvents() -> Observable<[ChannelModel]>? {
        guard let channelListModel = channelListModel else {
            return nil
        }
        
        let channels = Array(channelListModel.channelModels.prefix(5))
        let channelIds = channels.map { channelModel in
            return channelModel.id
        }

        return apiClient.requestChannelEvents(channels: channelIds)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { eventModels in
                eventModels.forEach{ eventModel in
                    let channel = channels.filter({ $0.id == eventModel.channelId }).first!
                    channel.events.append(eventModel)
                }
                return channels
            }
            .observeOn(MainScheduler.instance)
        
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
