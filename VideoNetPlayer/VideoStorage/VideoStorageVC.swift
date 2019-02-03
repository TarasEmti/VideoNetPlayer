//
//  VideoStorageVC.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit

class VideoStorageVC: UIViewController {
    
    let viewModel = VideoStorageVM()
    private var tableView: UITableView!
    
    private let itemCellIdentifier = "defaultCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Video Storage".localized
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: itemCellIdentifier)
    }
    
    override func viewWillLayoutSubviews() {
        tableView.frame = view.frame
    }
}

extension VideoStorageVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCellIdentifier)
        cell?.textLabel?.text = viewModel.titleForCell(at: indexPath)
        return cell ?? UITableViewCell()
    }
}

extension VideoStorageVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.onSelect(at: indexPath)
        navigationController?.popViewController(animated: true)
    }
}
