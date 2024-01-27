//
//  EventCollectionViewCell.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class EventCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var dateLabel: UILabel!
	@IBOutlet var nameLabel: UILabel!
	
	@IBOutlet var topLine: UIView!
	@IBOutlet var pointView: UIView!
	@IBOutlet var bottomLine: UIView!
	
	@IBOutlet var cardBackgroundView: UIView!
	
	func configure(with event: Event, isLast: Bool = false) {
		dateLabel.text = event.eventDate
		nameLabel.text = event.title
		
		bottomLine.layer.maskedCorners = isLast ? [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
		
		setup()
	}
	
	func setup() {
		pointView.clipsToBounds = true
		pointView.layer.cornerRadius = pointView.bounds.width / 2
		
		dateLabel.textColor = .systemOrange
		topLine.backgroundColor = .systemOrange.withAlphaComponent(0.64)
		pointView.backgroundColor = .systemOrange
		bottomLine.backgroundColor = .systemOrange.withAlphaComponent(0.64)
		
		bottomLine.layer.cornerRadius = 4
		
		cardBackgroundView.backgroundColor = .secondarySystemGroupedBackground
		
		cardBackgroundView.layer.cornerRadius = 16.0
		cardBackgroundView.layer.masksToBounds = true
		
		cardBackgroundView.layer.cornerRadius = 16
		cardBackgroundView.layer.shadowColor = UIColor.black.cgColor
		cardBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
		cardBackgroundView.layer.shadowRadius = 6.0
		cardBackgroundView.layer.shadowOpacity = 0.08
		cardBackgroundView.layer.masksToBounds = false
	}
}
