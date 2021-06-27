//
//  RepositoryTableViewCell.swift
//  BitBucketRepos
//
//  Created by achhatre on 27/06/21.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {

    weak var viewModel: ViewModel?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var typeLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var avatarImageView: UIImageView?
    
    var avatarImageURL: String = "" {
          didSet {
            viewModel?.loadImageResource(urlStr: avatarImageURL, completion: { (image) in
                DispatchQueue.main.async() { [weak self] in
                    self?.avatarImageView?.image = image
                }
            })
          }
    }
}
