//
//  ChannelTableViewModel.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class ChannelTableViewModel {
    var cellViewModels: [ChannelCellViewModel] = []
    var title = "Channel List"
    let channelsStore: IChannelsStore
    var signal: Variable<Bool> = Variable(true);
    var sortNumber = false;
    var sortLetter = false;
    
    init(channelsStore:IChannelsStore) {
        self.channelsStore = channelsStore
    }
    
    func requestChannels() {
        channelsStore.requestChannelList().subscribe(onNext: {  [unowned self] channelListModel in
            channelListModel.channelModels.forEach { channelModel in
                let viewModel = ChannelCellViewModel(model: channelModel, channelsStore: self.channelsStore)
                self.cellViewModels.append(viewModel)
            }
            self.signal.value = true
        })
    }
    
    func sortByChannelNumber() {
        sortLetter = false
        sortNumber = !sortNumber
        if (sortNumber) {
            cellViewModels.sort {
                $0.channelId < $1.channelId
            }
        } else {
            cellViewModels.sort {
                $0.channelId > $1.channelId
            }
        }
        signal.value = true
    }
    
    func sortByChannelName() {
        sortNumber = false
        sortLetter = !sortLetter
        if (sortLetter) {
            cellViewModels.sort {
                $0.channelName < $1.channelName
            }
        } else {
            cellViewModels.sort {
                $0.channelName > $1.channelName
            }
        }
        signal.value = true
    }
}

class ChannelCellViewModel {
    var channelName:String
    var channelId:Int
    var channelsStore:IChannelsStore
    
    var favorite: Bool {
        get {
            return channelsStore.isFavoriteById(channelId: channelId)
        }
        set {
            if (newValue) {
                channelsStore.setFavoriteById(channelId: channelId)
            } else {
                channelsStore.removeFavoriteById(channelId: channelId)
            }
        }
    }
    
    init(model: ChannelModel, channelsStore: IChannelsStore) {
        channelName = model.name
        channelId = model.id
        self.channelsStore = channelsStore
    }
    
    
}
