//
//  ProfileViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit

class ProfileViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchProfile()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSyncImage))
    }

    @objc func didTapSyncImage() {
        UserDefaults.standard.setImageCache(key: UserDefaultsKey.CACHE_PROFILE_IMAGE.rawValue, image: nil)
        
        models.removeAll()
        tableView.tableHeaderView = nil
        tableView.reloadData()
        fetchProfile()
    }
    
    private var models = [String]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchProfile() {
        APIManager.shared.getCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.onFetchProfileSuccess(with: response)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.onFetchProfileError()
                }
            }
        }
    }
    
    private func onFetchProfileSuccess(with model: UserProfile) {
        tableView.isHidden = false
        
        models.append("Full Name: \(model.displayName ?? "")")
        models.append("Email Address: \(model.email ?? "")")
        models.append("User ID: \(model.id ?? "")")
        models.append("Plan: \(model.product ?? "")")
        createTableHeader(with: model.images?.first?.url)
        tableView.reloadData()
    }
    
    private func createTableHeader(with string: String?) {
        guard let urlString = string, let url = URL(string: urlString) else {
            return
        }
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        let imageSize: CGFloat = headerView.height / 2
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
        headerView.addSubview(imageView)
        imageView.center = headerView.center
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.downloadImage(from: url, keyForCache: UserDefaultsKey.CACHE_PROFILE_IMAGE.rawValue)
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageSize / 2
        
        tableView.tableHeaderView = headerView
    }
    
    func onFetchProfileError() {
        let label = UILabel(frame: .zero)
        label.text = "Failed to load profile."
        label.sizeToFit()
        label.textColor = .secondaryLabel
        view.addSubview(label)
        label.center = view.center
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
