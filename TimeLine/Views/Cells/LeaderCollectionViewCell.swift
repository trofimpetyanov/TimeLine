//
//  LeaderCollectionViewCell.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class LeaderCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	
	private var isShadowOn = true
	
	override func setNeedsLayout() {
		super.setNeedsLayout()
		
		if isShadowOn {
			makeCornerRadiusAndShadow()
		} else {
			makeCornerRadius()
		}
	}
	
	func configure(with leader: Leader, isShadowOn: Bool = true) {
		imageView.image = UIImage(named: leader.imageName)
		nameLabel.text = leader.name
		dateLabel.text = leader.year
		
		self.isShadowOn = isShadowOn
		
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 8
	}
}
