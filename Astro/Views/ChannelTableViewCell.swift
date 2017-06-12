//
//  ChannelTableViewCell.swift
//  Astro
//
//  Created by Kevin Mun on 12/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var channelIdLabel: UILabel!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    var viewModel: ChannelCellViewModel? {
        didSet {
            invalidateView();
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func toggledSwitch(_ sender: UISwitch) {
        viewModel?.favorite = sender.isOn

    }
    
    func invalidateView() {
        if let viewModel = viewModel {
            channelNameLabel.text = viewModel.channelName
            channelIdLabel.text = String(viewModel.channelId)
            favoriteSwitch.isOn = viewModel.favorite
        }
    }
    
    
    
}
