//
//  DescriptionCollectionViewCell.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	
	override func setNeedsLayout() {
		super.setNeedsLayout()
		
		makeCornerRadius()
	}
	
	func configure(with event: Event) {
		nameLabel.text = event.title
		dateLabel.text = event.eventDate
		descriptionLabel.text = event.description
	}
}
