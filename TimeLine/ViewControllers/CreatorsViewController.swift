//
//  CreatorsViewController.swift
//  TimeLine
//
//  Created by Trofim Petyanov on 12/4/23.
//

import UIKit

class CreatorsViewController: UIViewController {

	@IBOutlet var trofimView: UIView!
	@IBOutlet var trofimImageView: UIImageView!
	
	@IBOutlet var stasView: UIView!
	@IBOutlet var statImageView: UIImageView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		for creatorView in [trofimView, stasView] {
			creatorView?.layer.cornerRadius = 16.0
			creatorView?.layer.masksToBounds = true
			
			creatorView?.layer.cornerRadius = 16
			creatorView?.layer.shadowColor = UIColor.black.cgColor
			creatorView?.layer.shadowOffset = CGSize(width: 0, height: 2.0)
			creatorView?.layer.shadowRadius = 8.0
			creatorView?.layer.shadowOpacity = 0.08
			creatorView?.layer.masksToBounds = false
		}
		
		for imageView in [trofimImageView, statImageView] {
			imageView?.layer.cornerRadius = 16.0
			imageView?.layer.masksToBounds = true
		}
    }

}
