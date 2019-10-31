//
//  ImagePostDetailTableViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/14/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit

class ImagePostDetailTableViewController: UITableViewController {
    
    // MARK: - IBOutlets & Properties
    
    var post: Post!
    var postController: PostController!
    var imageData: Data?
    var comment: CommentType?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageViewAspectRatioConstraint: NSLayoutConstraint!
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewWithComment(from:)), name: .commentMade, object: nil)
    }
    
    
    
    // MARK: - Methods
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else { return }
        
        title = post?.title
        
        imageView.image = image
        
        titleLabel.text = post.title
        authorLabel.text = post.author.displayName
        tableView.reloadData()
    }
    
    
    
    //MARK: - Comment Action Sheet
    
    @IBAction func createComment(_ sender: Any) {
        let choiceAlert = UIAlertController(title: "What kind of Comment do you want to Leave?", message: "Choose from down below:", preferredStyle: .actionSheet)
        
        let textCommentAction = UIAlertAction(title: "Text", style: .default) { (_) in
            DispatchQueue.main.async {
                self.addTextComment()
            }
        }
        
        let audioCommentAction = UIAlertAction(title: "Audio", style: .default) { (_) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "AddAudioSegue", sender: self)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        choiceAlert.addAction(textCommentAction)
        choiceAlert.addAction(audioCommentAction)
        choiceAlert.addAction(cancelAction)
        
        present(choiceAlert, animated: true, completion: nil)
    }
    
    func addTextComment() {
        let alert = UIAlertController(title: "Add a comment", message: "Write your comment below:", preferredStyle: .alert)
        
        var commentTextField: UITextField?
        
        alert.addTextField { (textField) in
            textField.placeholder = "Comment:"
            commentTextField = textField
        }
        
        let addCommentAction = UIAlertAction(title: "Add Comment", style: .default) { (_) in
            
            guard let commentText = commentTextField?.text else { return }
            
            self.postController.addComment(with: commentText, to: &self.post!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addCommentAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddAudioSegue" {
            guard let recordVC = segue.destination as? RecordCommentViewController else { return }
            recordVC.postController = postController
            recordVC.post = post
        }
    }
    
    //MARK: - Set Comment Type
    
    @objc func updateTableViewWithComment(from notification: NSNotification) {
        guard let chosenComment = notification.userInfo?["commentType"] as? CommentType else { return }
        comment = chosenComment
        updateViews()
    }
    
        // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Text Comments"
        case 1:
            return "Audio Comments"
        default:
            return "BROKE"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (post?.comments.count ?? 0) - 1
        case 1:
            return (post?.audioComments.count ?? 0) - 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch comment {
        case .text:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
            let comment = post?.comments[indexPath.row + 1]
            cell.textLabel?.text = comment?.text
            cell.detailTextLabel?.text = comment?.author.displayName
            return cell
        case .audio:
            guard let audioCell = tableView.dequeueReusableCell(withIdentifier: "AudioCell", for: indexPath) as? AudioCommentTableViewCell else { return UITableViewCell()}
            let audioComment = post?.audioComments[indexPath.row + 1]
            audioCell.audioComment = audioComment
            return audioCell
        default:
            return UITableViewCell()
        }
    }
}
