//
//  OfflineTableViewCell.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 24/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit
import SDWebImage

class OfflineTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(article: PageDataItem) {
//        self.article = article
        self.thumbnailImageView.sd_setImage(with: URL.init(string: article.thumbnail?.source ?? ""), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.terms?.description.first ?? ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
