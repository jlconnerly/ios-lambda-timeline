//
//  RecordCommentViewController.swift
//  LambdaTimeline
//
//  Created by Jake Connerly on 10/30/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class RecordCommentViewController: UIViewController {

    @IBOutlet weak var recordCommentButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
    }
    
}