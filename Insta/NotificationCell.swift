//
//  AATableViewCell.swift
//  Insta
//
//  Created by AriChou on 2/22/21.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate: class {
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String)
}

class NotificationCell: UITableViewCell {
    
    weak var delegate: NotificationCellDelegate?

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var postImageView: UIImageView!
    
    var viewModel: NotificationViewModel? {
        didSet {
            guard let viewModel = viewModel else { return }
            profileImageView.sd_setImage(with: viewModel.profileImageUrl, completed: nil)
            postImageView.sd_setImage(with: viewModel.postImageUrl, completed: nil)
            infoLabel.attributedText = viewModel.notificationMessage
            postImageView.isHidden = viewModel.hidePostImage
            followButton.isHidden = !viewModel.hidePostImage
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        followButton.isHidden = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostImageTapped))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tap)
        
       
    }
    
    @objc func handlePostImageTapped() {
        guard let viewModel = viewModel else { return }
        guard let postId = viewModel.notification.postId else { return }
        delegate?.cell(self, wantsToViewPost: postId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
