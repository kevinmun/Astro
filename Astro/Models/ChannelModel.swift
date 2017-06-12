//
//  ChannelModel.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation

class ChannelModel {
    var name: String
    var id: Int = -1
    
    init(data: [String: Any]) {
        name = data["channelTitle"] as! String
        id = data["channelId"] as! Int
    }
}
