//
//  HomeViewController.swift
//  Safetant
//
//  Created by Yusuf Umar Hanafi on 18/08/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private lazy var driveStatusText: UILabel = {
        let statusText = UILabel()
        statusText.text = "Driver Status"
        statusText.textAlignment = .center
        statusText.font = .systemFont(ofSize: 18, weight: .bold)
        statusText.translatesAutoresizingMaskIntoConstraints = false
        statusText.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        
        return statusText
    }()
    
    private lazy var statusUserText: UILabel = {
        let statusUserText = UILabel()
        statusUserText.text = "is Driving"
        statusUserText.textAlignment = .center
        statusUserText.font = .systemFont(ofSize: 16, weight: .regular)
        statusUserText.translatesAutoresizingMaskIntoConstraints = false
        statusUserText.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        
        return statusUserText
    }()
    
    private lazy var cardSummary: UIView = {
        let card = UIView()
        card.backgroundColor = .blue
        
        return card
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        view.addSubview(cardSummary)
//        cardSummary.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        cardSummary.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        cardSummary.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        cardSummary.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        cardSummary.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        cardSummary.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        cardSummary.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Home"
    }
}
