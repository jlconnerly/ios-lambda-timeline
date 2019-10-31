//
//  AudioCommentTableViewCell.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class AudioCommentTableViewCell: UITableViewCell {
    
    var audioComment: AudioComment?

    @IBOutlet weak var playStopButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    @IBAction func playStopButtonPressed(_ sender: UIButton) {
    }
    
}
