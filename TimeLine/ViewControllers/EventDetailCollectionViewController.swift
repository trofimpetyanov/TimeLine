//
//  EventDetailCollectionViewController.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit
import SafariServices

class EventDetailCollectionViewController: UICollectionViewController {
	typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
	
	enum SupplementaryViewKind {
		static let header = "header"
	}
	
	struct ViewModel {
		enum Section {
			case image
			case description
			case leaders
			case influence
		}
		
		enum Item: Hashable {
			case image(Event)
			case description(Event)
			case influence(Event)
			case leader(Leader)
			
			func hash(into hasher: inout Hasher) {
				switch self {
				case .image(let event):
					hasher.combine(event.imageName)
				case .description(let event):
					hasher.combine(event.title)
				case .influence(let event):
					hasher.combine(event.influence)
				case .leader(let leader):
					hasher.combine(leader)
				}
			}
		}
	}
	
	var event: Event
	var dataSource: DataSourceType!
	
	init?(event: Event, coder: NSCoder) {
		self.event = event
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	//MARK: – Helpers
	private func setup() {
		dataSource = createDataSource()
		collectionView.dataSource = dataSource
		collectionView.collectionViewLayout = createLayout()
		
		collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: SectionHeaderView.reuseIdentifier)
		
		updateCollectionView()
	}
	
	//MARK: – Update
	private func updateCollectionView() {
		updateSnapshot()
	}
	
	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
		
		let image = ViewModel.Item.image(event)
		let description = ViewModel.Item.description(event)
		let influence = ViewModel.Item.influence(event)
		let leaders = event.leaderIds.compactMap({ Settings.leaderForId($0) }).map({ ViewModel.Item.leader($0) })
		
		snapshot.appendSections([.image, .description, .influence])
		snapshot.appendItems([image], toSection: .image)
		snapshot.appendItems([description], toSection: .description)
		snapshot.appendItems([influence], toSection: .influence)
		
		if leaders.count > 0 {
			snapshot.appendSections([.leaders])
			snapshot.appendItems(leaders, toSection: .leaders)
		}
		
		dataSource.apply(snapshot)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let section = dataSource.sectionIdentifier(for: indexPath.section),
			section == .leaders,
			case let .leader(leader) = dataSource.itemIdentifier(for: indexPath),
			let url = URL(string: leader.url)
		else { return }
		
		let sfSafariViewController = SFSafariViewController(url: url)
		
		present(sfSafariViewController, animated: true)
	}
	
	//MARK: – Data Source
	private func createDataSource() -> DataSourceType {
		let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) in
			switch itemIdentifier {
			case .image(let event):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
				
				cell.configure(with: event)
				
				return cell
			case .description(let event):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "descriptionCell", for: indexPath) as! DescriptionCollectionViewCell
				
				cell.configure(with: event)
				
				return cell
			case .influence(let event):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "influenceCell", for: indexPath) as! InfluenceCollectionViewCell
				
				cell.configure(with: event)
				
				return cell
			case .leader(let leader):
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leaderCell", for: indexPath) as! LeaderCollectionViewCell
				
				cell.configure(with: leader, isShadowOn: false)
				
				return cell
			}
		}
		
		dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
			let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.reuseIdentifier, for: indexPath) as! SectionHeaderView
			
			switch section {
			case .influence:
				headerView.setTitle("Роль в становлении РФ")
			case .leaders:
				headerView.setTitle("Правители")
			default:
				break
			}
			
			return headerView
		}
		
		return dataSource
	}
	
	//MARK: – Layout
	private func createLayout() -> UICollectionViewCompositionalLayout {
		let padding: CGFloat = 16
		
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			let widthSize = layoutEnvironment.traitCollection.horizontalSizeClass
			let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
			let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
			
			
			let section = self.dataSource.snapshot().sectionIdentifiers[sectionIndex]
			
			switch section {
			case .image:
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				
				let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
				
				let section = NSCollectionLayoutSection(group: group)
				section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: 0, trailing: padding)
				
				return section
			case .description:
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				
				let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
				
				let section = NSCollectionLayoutSection(group: group)
				section.contentInsets = NSDirectionalEdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding)
				
				return section
			case .influence:
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				
				let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(300))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
				
				let section = NSCollectionLayoutSection(group: group)
				section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: padding, trailing: padding)
				section.boundarySupplementaryItems = [headerItem]
				
				return section
			case .leaders:
				let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthSize == .compact ? 1 : 1/2), heightDimension: .fractionalHeight(1))
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				
				let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: widthSize == .compact ? [item] : [item, item])
				group.interItemSpacing = .fixed(padding)
				
				let section = NSCollectionLayoutSection(group: group)
				section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: padding, bottom: padding, trailing: padding)
				section.interGroupSpacing = padding
				
				section.boundarySupplementaryItems = [headerItem]
				
				return section
			}
		}
		
		return layout
	}
}
