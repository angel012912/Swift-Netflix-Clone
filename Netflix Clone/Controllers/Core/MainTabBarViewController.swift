//
//  ViewController.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 20/06/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Se asignan los controladores de la vista para cada control de navegacion
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())
        
        // Se definen iconos para cada controlador de navegacion
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        // Se asignan titulos
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
        
        // Se cambia el color de la tinta
        tabBar.tintColor = .label
        
        
        // Se asignan los controladores al array de controladores de vista
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}

