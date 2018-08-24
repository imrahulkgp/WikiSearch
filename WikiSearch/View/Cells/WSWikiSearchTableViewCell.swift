//
//  WSWikiSearchTableViewCell.swift
//  WikiSearch
//
//  Created by Rahul Gupta on 23/08/18.
//  Copyright © 2018 MoneyTap. All rights reserved.
//

import UIKit
import SDWebImage

protocol WSWikiSearchTableViewCellDelegate: class {
    func didTapOnDownloadButton(forCell cell:WSWikiSearchTableViewCell)
}

class WSWikiSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    
    weak var delegate: WSWikiSearchTableViewCellDelegate?
    var article: PageDataItem?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbnailImageView.layer.cornerRadius = 5
    }

    func setup(article: PageDataItem) {
        self.article = article
        self.thumbnailImageView.sd_setImage(with: URL.init(string: article.thumbnail?.source ?? ""), placeholderImage: UIImage.init(named: "placeholder"), options: SDWebImageOptions.cacheMemoryOnly, completed: nil)
        self.titleLabel.text = article.title
        self.descriptionLabel.text = article.terms?.description.first ?? ""
    }
    
    @IBAction func downloadAction(_ sender: Any) {
        self.delegate?.didTapOnDownloadButton(forCell: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
