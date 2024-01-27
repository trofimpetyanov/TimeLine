//
//  InfluenceCollectionViewCell.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class InfluenceCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var label: UILabel!
	
	override func setNeedsLayout() {
		super.setNeedsLayout()
		
		makeCornerRadius()
	}
	
	func configure(with event: Event) {
		label.text = event.influence
	}
}
