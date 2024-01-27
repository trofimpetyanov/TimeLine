//
//  TimelineSectionHeaderView.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class CenturySectionHeaderView: UICollectionReusableView {
	static let reuseIdentifier = "centuryReusableView"
	
	let titleLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 20, weight: .medium)
		label.textColor = .secondaryLabel
		return label
	}()
	
	let blurEffectView: UIView = {
		let blurEffect = UIBlurEffect(style: .prominent)
		let blurEffectView = UIVisualEffectView(effect: blurEffect)
		
		return blurEffectView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .systemBackground
		
//		blurEffectView.translatesAutoresizingMaskIntoConstraints = false
//		addSubview(blurEffectView)
//		
//		NSLayoutConstraint.activate([
//			blurEffectView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
//			blurEffectView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
//			blurEffectView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
//			blurEffectView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
//		])
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(with title: String) {
		titleLabel.text = title
	}
}
