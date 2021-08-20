//
//  HomeViewController.swift
//  Safetant
//
//  Created by Yusuf Umar Hanafi on 18/08/21.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Home"
    }


}
