//
//  TimeLineCollectionViewController.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 21.10.2023.
//

import UIKit

class TimeLineCollectionViewController: UICollectionViewController {
	typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
	
	enum SupplementaryViewKind {
		static let header = "header"
	}
	
	struct ViewModel {
		typealias Section = Century
		typealias Item = Event
	}
	
	struct Model {
		var centuries: [Century] {
			Settings.shared.sections
		}
	}
	
	let model = Model()
	var dataSource: DataSourceType!
	var selectedCentury: Century?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setup()
	}
	
	//MARK: – Helpers
	private func setup() {
		dataSource = createDataSource()
		collectionView.dataSource = dataSource
		collectionView.collectionViewLayout = createLayout()
		
		collectionView.register(TimeLineSectionHeaderView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header, withReuseIdentifier: TimeLineSectionHeaderView.reuseIdentifier)
		
		updateCollectionView()
	}
	
	//MARK: – Update
	private func updateCollectionView() {
		updateSnapshot()
	}
	
	private func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
		
		let centuries = model.centuries
		
		for century in centuries {
			guard let events = century.events, events.count > 0 else { continue }
			
			snapshot.appendSections([century])
			snapshot.appendItems(events, toSection: century)
		}
		
		dataSource.apply(snapshot)
	}
	
	@IBSegueAction func showEventDetail(_ coder: NSCoder, sender: Any?) -> EventDetailCollectionViewController? {
		guard let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first, let event = dataSource.itemIdentifier(for: selectedIndexPath) else { return nil }
		
		return EventDetailCollectionViewController(event: event, coder: coder)
	}
	
	//MARK: – Data Source
	private func createDataSource() -> DataSourceType {
		let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) in
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as! EventCollectionViewCell
			
			let centuries = self.model.centuries
			let events = centuries[indexPath.section].events
			let isLast = (indexPath.section + 2 == centuries.count) && (indexPath.row + 1 == events?.count)
			
			cell.configure(with: itemIdentifier, isLast: isLast)
			
			return cell
		}
		
		dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
			let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
			
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TimeLineSectionHeaderView.reuseIdentifier, for: indexPath) as! TimeLineSectionHeaderView
			
			let placement: Placement = indexPath.section == 0 ? .top : .middle
			headerView.configure(with: section.title, placement: placement)
			headerView.setAction { [weak self] in
				self?.selectedCentury = section
				self?.performSegue(withIdentifier: "showLeadersSegue", sender: nil)
			}
			
			return headerView
		}
		
		return dataSource
	}
	
	//MARK: – Layout
	private func createLayout() -> UICollectionViewCompositionalLayout {
		let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
			let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
			let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header, alignment: .top)
			
			let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
			let item = NSCollectionLayoutItem(layoutSize: itemSize)
			
			let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120))
			let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 1)
			
			let section = NSCollectionLayoutSection(group: group)
			
			section.boundarySupplementaryItems = [headerItem]
			
			return section
		}
		
		return layout
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		guard segue.identifier == "showLeadersSegue",
			  let leadersCollectionViewController = segue.destination as? CenturyLeadersCollectionViewController,
			  let selectedCentury = selectedCentury
		else { return }
		
		leadersCollectionViewController.shouldDisplayHeaders = false
		leadersCollectionViewController.century = selectedCentury
	}
	
	@IBAction func unwindToTimeLine(sender: UIStoryboardSegue) {
		
	}
}
