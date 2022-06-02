//
//  NewsListCell.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import UIKit
import SDWebImage

class NewsListCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelUpdateTime: UILabel!
    @IBOutlet weak var imgViewThumb: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateDisplay(_ display: NewsListDisplayModel) {
        self.labelTitle.text = display.title
        self.labelUpdateTime.text = display.updatedTime
        if let imageURL = display.imageURL {
            self.imgViewThumb.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: "default-thumbnail"))
        }
        
        self.labelDescription.text = display.description
    }
}
