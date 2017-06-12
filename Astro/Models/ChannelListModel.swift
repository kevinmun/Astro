//
//  ChannelListModel.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation

class ChannelListModel {
    var channelModels: [ChannelModel] = []
    
    init(data: [String : Any]) {
        if let rawChannelData = data["channels"] as? [[String: Any]] {
            rawChannelData.forEach { channelData in
                let model = ChannelModel(data: channelData)
                channelModels.append(model)
            }
        }
    }
}
