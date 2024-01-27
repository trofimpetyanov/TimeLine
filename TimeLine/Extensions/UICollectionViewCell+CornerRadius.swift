//
//  UICollectionViewCell+CornerRadius.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 22.10.2023.
//

import UIKit

extension UICollectionViewCell {
	
	func makeCornerRadiusAndShadow() {
		makeCornerRadius()
		makeShadow()
	}
	
	func makeCornerRadius() {
		layer.cornerRadius = 16.0
		layer.masksToBounds = true
	}
	
	func makeShadow() {
		layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 2)
		layer.shadowRadius = 6.0
		layer.shadowOpacity = 0.08
		layer.masksToBounds = false
	}
}
