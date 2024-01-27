//
//  TimelineSectionHeaderView.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class TimeLineSectionHeaderView: UICollectionReusableView {
	static let reuseIdentifier = "timelineReusableView"
	
	let titleButton: UIButton = {
		let imageConfiguration = UIImage.SymbolConfiguration(hierarchicalColor: .lightGray)
		
		var buttonConfiguration = UIButton.Configuration.plain()
		buttonConfiguration.image = UIImage(systemName: "chevron.forward.circle.fill", withConfiguration: imageConfiguration)
		buttonConfiguration.imagePadding = 8
		buttonConfiguration.imagePlacement = .trailing
		
		let button = UIButton(configuration: buttonConfiguration)
		
		return button
	}()
	
	let line: UIView = {
		let view = UIView()
		view.backgroundColor = .systemOrange.withAlphaComponent(0.64)
		return view
	}()
	
	var action: (() -> Void)? {
		didSet {
			titleButton.removeTarget(nil, action: nil, for: .allEvents)
			titleButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
		}
	}
	
	func configure(with title: String, placement: Placement) {
		var attributeContainer = AttributeContainer()
		attributeContainer.font = .systemFont(ofSize: 20, weight: .medium)
		attributeContainer.foregroundColor = .lightGray
		
		titleButton.configuration?.attributedTitle = AttributedString(title, attributes: attributeContainer)
		
		line.clipsToBounds = true
		line.layer.cornerRadius = 4
		
		switch placement {
		case .top:
			line.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		default:
			line.layer.maskedCorners = []
		}
	}
	
	func setAction(_ action: @escaping () -> Void) {
		self.action = action
	}
	
	@objc func callAction() {
		action?()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(line)
		line.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			line.widthAnchor.constraint(equalToConstant: 8),
			line.topAnchor.constraint(equalTo: topAnchor),
			line.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			line.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
		
		addSubview(titleButton)
		titleButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			titleButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
			titleButton.leadingAnchor.constraint(equalTo: line.trailingAnchor, constant: 20),
			titleButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
		])
		
		backgroundColor = .clear
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
