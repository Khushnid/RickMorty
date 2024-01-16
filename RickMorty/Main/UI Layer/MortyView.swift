//
//  MortyView.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyView: UIView {
    var onNewPageRequest: (() -> Void)?
    
    private var dataSource = [MortyModelResult]() {
        didSet {
            guard !dataSource.isEmpty else { return }
            tableView.reloadData()
        }
    }
    
    private let loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.color = .darkText
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MortyContentCell.self, forCellReuseIdentifier: MortyContentCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewsAndConstraints()
        setupPrerequisites()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Interaction with controller
extension MortyView {
    func setDataSource(dataSource: [MortyModelResult]) {
        self.dataSource += dataSource
    }
    
    func startLoading() {
        loader.startAnimating()
    }
    
    func stopLoading() {
        loader.stopAnimating()
    }
}

extension MortyView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MortyContentCell.reuseID) as? MortyContentCell else {
            return UITableViewCell()
        }
        
        guard let contentData = dataSource[safe: indexPath.row] else { return cell }
        cell.setupContentData(data: contentData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == dataSource.count - 1 else { return }
        onNewPageRequest?()
    }
}

private extension MortyView {
    func setupViewsAndConstraints() {
        addSubview(tableView)
        addSubview(loader)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupPrerequisites() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
