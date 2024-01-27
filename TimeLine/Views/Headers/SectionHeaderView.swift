import UIKit

class SectionHeaderView: UICollectionReusableView {
	static let reuseIdentifier = "SectionHeaderView"
	
	let label: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
		label.textColor = .label
		
		return label
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		label.translatesAutoresizingMaskIntoConstraints = false
		addSubview(label)
		
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: topAnchor, constant: 0),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
			label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func setTitle(_ title: String) {
		label.text = title
	}
}
