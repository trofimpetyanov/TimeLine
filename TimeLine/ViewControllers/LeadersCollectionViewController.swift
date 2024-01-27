//
//  LeadersCollectionViewController.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 22.10.2023.
//

import UIKit
import SafariServices

class LeadersCollectionViewController: UICollectionViewController {
	typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
	
	enum SupplementaryViewKind {
		static let header = "header"
	}
	
	struct ViewModel {
		typealias Section = Century
		typealias Item = Leader
	}
	
	var shouldDisplayHeaders = true
	var dataSource: DataSourceType!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	//MARK: – Helpers
	func setup() {
		dataSource = createDataSource()
		collectionView.dataSource = dataSource
		collectionView.collectionViewLayout = createLayout()
		
		collectionView.register(CenturySectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: CenturySectionHeaderView.reuseIdentifier)
		
		updateCollectionView()
	}
	
	//MARK: – Update
	func updateCollectionView() {
		updateSnapshot()
	}
	
	func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
		
		let centuries = Settings.shared.sections
		
		for century in centuries {
			let leadersIDs = century.leaders
			let leaders = leadersIDs.compactMap { Settings.leaderForId($0) }
			
			guard leaders.count > 0 else { continue }
			
			snapshot.appendSections([century])
			snapshot.appendItems(leaders, toSection: century)
		}
		
		dataSource.apply(snapshot)
	}
	
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let leader = dataSource.itemIdentifier(for: indexPath),
			let url = URL(string: leader.url)
		else { return }
		
		let sfSafariViewController = SFSafariViewController(url: url)
		
		present(sfSafariViewController, animated: true)
	}
	
	//MARK: – Data Source
	private func createDataSource() -> DataSourceType {
		let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "leaderCell", for: indexPath) as! LeaderCollectionViewCell
			
			cell.configure(with: itemIdentifier)
			cell.setNeedsLayout()
			cell.layoutIfNeeded()
			
			return cell
		}
		
		dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
			let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CenturySectionHeaderView.reuseIdentifier, for: indexPath) as! CenturySectionHeaderView
			
			headerView.configure(with: section.title)
			
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
			headerItem.pinToVisibleBounds = true
			
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(widthSize == .compact ? 1 : 1/2), heightDimension: .fractionalHeight(1))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(160))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: widthSize == .compact ? [item] : [item, item])
			group.interItemSpacing = .fixed(padding)
			
			let section = NSCollectionLayoutSection(group: group)
			section.contentInsets = NSDirectionalEdgeInsets(top: padding / 2, leading: padding, bottom: padding, trailing: padding)
			section.interGroupSpacing = padding
			
			section.boundarySupplementaryItems = self.shouldDisplayHeaders ? [headerItem] : []
			section.supplementaryContentInsetsReference = .none
			
			return section
		}
		
		return layout
	}
}
