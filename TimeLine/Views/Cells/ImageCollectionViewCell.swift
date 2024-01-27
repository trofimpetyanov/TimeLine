//
//  ImageCollectionViewCell.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var imageView: UIImageView!
	
	func configure(with event: Event) {
		let image = UIImage(named: event.imageName)
		
		imageView.image = image

		imageView.layer.cornerRadius = 16.0
	}
}
