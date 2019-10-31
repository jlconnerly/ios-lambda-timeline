//
//  Player.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/31/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import AVFoundation

protocol PlayerDelegate {
    func playerDidChangeState(player: Player)
}

class Player: NSObject {
    
    var audioPlayer: AVAudioPlayer?
    
    
    
}
