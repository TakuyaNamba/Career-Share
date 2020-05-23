//
//  MessageCell.swift
//  Career Share
//
//  Created by 難波 拓也 on 2020/04/17.
//  Copyright © 2020 Takuya Namba. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    
    
    @IBOutlet weak var leftImagaButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func commentPressed(_ sender: UIButton) {
    }
    @IBAction func leftImagePressed(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
