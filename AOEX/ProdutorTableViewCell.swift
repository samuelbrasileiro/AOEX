//
//  ProdutorTableViewCell.swift
//  AOEX
//
//  Created by Samuel Brasileiro on 20/06/20.
//  Copyright © 2020 Samuel Brasileiro. All rights reserved.
//

import UIKit
protocol ProdutorCellDelegate
{
    func knowMoreButtonTapped(cell: ProdutorTableViewCell);
}

class ProdutorTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var placeLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var baseView: UIView!
    
    var delegate: ProdutorCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        userImage.layer.masksToBounds = true
        userImage.layer.cornerRadius = userImage.frame.width/2
        
        userImage.contentMode = .scaleAspectFill
        
        
    }

    @IBAction func knowMoreButtonTapped(_ sender: Any) {
        delegate?.knowMoreButtonTapped(cell: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
