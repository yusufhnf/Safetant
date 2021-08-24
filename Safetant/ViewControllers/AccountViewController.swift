//
//  AccountViewController.swift
//  Safetant
//
//  Created by Yusuf Umar Hanafi on 18/08/21.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private lazy var userNameText: UILabel = {
        let nameText = UILabel()
        nameText.text = "Richard Ruslan"
        nameText.textAlignment = .left
        nameText.font = .systemFont(ofSize: 18, weight: .bold)
        nameText.translatesAutoresizingMaskIntoConstraints = false
        nameText.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        
        return nameText
    }()
    
    private lazy var userEmailText: UILabel = {
        let emailText = UILabel()
        emailText.text = "richardrus@guava.com"
        emailText.textAlignment = .left
        emailText.font = .systemFont(ofSize: 16, weight: .regular)
        emailText.translatesAutoresizingMaskIntoConstraints = false
        emailText.textColor = UIColor(red: 130/255, green: 131/255, blue: 134/255, alpha: 1)
        
        return emailText
    }()
    
    private lazy var userPicturePicture: UIImage = {
        let userImage = UIImage()
        
        return userImage
    }()

    private func setupNavigationBar() {
        self.navigationItem.title = "Account"
    }
    
    
    
    private func accountInformation() {
        
    }

}
