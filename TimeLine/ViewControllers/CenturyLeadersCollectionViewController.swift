//
//  CenturyLeadersCollectionViewController.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 22.10.2023.
//

import UIKit

class CenturyLeadersCollectionViewController: LeadersCollectionViewController {

	var century: Century?
	
	override func setup() {
		super.setup()
		
		if let century = century {
			title = century.title
		}
	}
	
	override func updateSnapshot() {
		var snapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Item>()
		
		guard let century = century else { return }
		
		let leaders = century.leaders.compactMap({ Settings.leaderForId($0) })
		
		if leaders.count > 0 {
			snapshot.appendSections([century])
			snapshot.appendItems(leaders, toSection: century)
		}
			
		dataSource.apply(snapshot)
	}
}
