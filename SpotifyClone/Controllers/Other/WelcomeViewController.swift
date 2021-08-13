//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTappedSignIn), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height - 50 - view.safeAreaInsets.bottom,
            width: view.width - 40,
            height: 50
        )
    }
    
    @objc func didTappedSignIn() {
        let viewController = AuthenticatorViewController()
        viewController.signInDidCompleted = { [weak self] result in
            DispatchQueue.main.async {
                self?.signInDidCompleted(result: result)
            }
        }
        viewController.navigationItem.largeTitleDisplayMode = .always
        navigationController?.pushViewController(viewController, animated: true)
    }
        
    private func signInDidCompleted(result: Bool) {
        guard result else {
            
            let alert = UIAlertController(title: "Atenttion", message: "Error on signing with Spotify.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            return
        }
        
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        present(tabBarController, animated: true)
    }
}
