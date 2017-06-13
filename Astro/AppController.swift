//
//  AppController.swift
//  Plain
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import UIKit

protocol IAppController {
    func launch();
}

class AppController : IAppController {
    var window: UIWindow!
    var mainTabController: UITabBarController!
    var channelTableViewController: ChannelTableViewController!
    var channelCollectionViewController: ChannelCollectionViewController!
    
    var apiClient = APIClient()
    var channelsStore: IChannelsStore!
    
    func launch() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        channelsStore = ChannelsStore(apiClient: apiClient)
        
        channelTableViewController = ChannelTableViewController(nibName: "ChannelTableViewController", bundle: nil)
        let viewModel = ChannelTableViewModel(channelsStore: channelsStore)
        channelTableViewController.viewModel = viewModel
        
        channelCollectionViewController = ChannelCollectionViewController(nibName: "ChannelCollectionViewController", bundle: nil)
        
        let channelNavigationController = UINavigationController(rootViewController: channelTableViewController)
        let collectionNavigationController = UINavigationController(rootViewController: channelCollectionViewController)
        
        mainTabController = UITabBarController()
        mainTabController.viewControllers = [channelNavigationController, collectionNavigationController]
        
        
        window.rootViewController = mainTabController
        window.makeKeyAndVisible()
    }
}

