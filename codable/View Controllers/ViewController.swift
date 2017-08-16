//
//  ViewController.swift
//  codable
//
//  Created by Patrick McCarron on 8/6/17.
//  Copyright © 2017 Patrick McCarron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiManager = OraAPIManager()
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    @IBAction func login() {
        if !apiManager.isAuthorized() {
            apiManager.requestAuth { [weak self] in
                DispatchQueue.main.async {
                    self?.loginButton.titleLabel?.text = "Logout"
                    self?.performSegue(withIdentifier: "viewMessages", sender: nil)
                }
            }
        } else {
            apiManager.clearAuth()
            DispatchQueue.main.async { [weak self] in
                self?.loginButton.titleLabel?.text = "Login"
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController,
            let vc = nav.topViewController as? MessagesViewController,
            segue.identifier == "viewMessages" {
            vc.apiManager = self.apiManager
        }
    }
}

