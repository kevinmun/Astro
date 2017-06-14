//
//  EventModel.swift
//  Astro
//
//  Created by Kevin Mun on 14/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import Foundation


class EventModel {
    var name: String
    var id: Int
    var dateTime: Date
    var duration: Int = 0
    var channelId: Int
    
    init(data:[String:Any]) {
        name = data["programmeTitle"] as! String
        id = data["eventId"] as! Int
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
        dateTime = dateFormatter.date(from: data["displayDateTimeUtc"] as! String)!
        
        let displayDuration = data["displayDuration"] as! String
        let durationComponents = displayDuration.components(separatedBy: ":")
        
        for (index, component) in durationComponents.enumerated() {
            if (index == 0) {
                duration += Int(component)! * 60 * 60
            } else if (index == 1) {
                duration += Int(component)! * 60
            } else {
                duration += Int(component)!
            }
        }
        channelId = data["channelId"] as! Int
    }
}
