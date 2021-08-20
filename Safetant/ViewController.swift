//
//  ViewController.swift
//  Safetant
//
//  Created by Yusuf Umar Hanafi on 16/08/21.
//

import UIKit

class ViewController: UITabBarController {
    
    private lazy var home: UIViewController = {
        let vc = HomeViewController()
        let image = UIImage(systemName: "house")
        let selectedImage = UIImage(systemName: "house.fill")
        vc.tabBarItem = UITabBarItem(title: "Beranda", image: image, selectedImage: selectedImage)
        return UINavigationController(rootViewController: vc)
    }()
    
    private lazy var about: UIViewController = {
        let vc = AccountViewController()
        let image = UIImage(systemName: "person.crop.circle")
        let selectedImage = UIImage(systemName: "person.crop.circle.fill")
        vc.tabBarItem = UITabBarItem(title: "Account", image: image, selectedImage: selectedImage)
        return UINavigationController(rootViewController: vc)
    }()
    
    private func setupTabbar() {
        self.viewControllers = [home, about]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }


}

