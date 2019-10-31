//
//  RecordCommentViewController.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum CommentType: String {
    case text
    case audio
}

class RecordCommentViewController: UIViewController {

    @IBOutlet weak var recordCommentButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    
    var player: Player = Player(url: nil)
    var recorder: Recorder = Recorder()
    var postController: PostController?
    var post: Post?
    var commentType: CommentType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        player.delegate = self
        recorder.delegate = self
        saveButton.isEnabled = false
        updateViews()
    }
    
    private func updateViews() {
        let playButtonTitle = player.isPlaying ? "Pause" : "Play"
        playButton.setTitle(playButtonTitle, for: .normal)
        
        let recordButtonTitle = recorder.isRecording ? "Stop Recording" : "Record Comment"
        recordCommentButton.setTitle(recordButtonTitle, for: .normal)
        
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(player.duration)
        timeSlider.value = Float(player.timeElapsed)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordButtonPressed(_ sender: UIButton) {
        recorder.toggleRecording()
        
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        player.playPause()
        saveButton.isEnabled = true
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let url = recorder.url,
              let postController = postController else { return }
        postController.addAudioComment(from: url, to: &(post)!)
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension RecordCommentViewController: PlayerDelegate {
    func playerDidChangeState(player: Player) {
        // update the UI
        
        updateViews()
    }
}

extension RecordCommentViewController: RecorderDelegate {
    func recorderDidChangeState(recorder: Recorder) {
        updateViews()
    }
    
    func recorderDidSaveFile(recorder: Recorder) {
        updateViews()
        
        // TODO: Play the file
        if let url = recorder.url, recorder.isRecording == false {
            // Recording is finished, let's try and play the file
            
            player = Player(url: url)
            player.delegate = self
        }
    }
}
