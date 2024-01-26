//
//  MortyView.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyView: UIView {
    var onNewPageRequest: (() -> Void)?
    
    private var dataSource = [MortyModel.MortyModelResult]() {
        didSet {
            guard !dataSource.isEmpty else { return }
            tableView.reloadData()
        }
    }

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
    
    func setDataSource(dataSource: [MortyModel.MortyModelResult]) {
        self.dataSource += dataSource
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
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: .zero, y: .zero, width: tableView.bounds.width, height: CGFloat(44))
        spinner.hidesWhenStopped = true
        
        let lastSectionIndex = tableView.numberOfSections - 1
        guard indexPath.section == lastSectionIndex && indexPath.row == tableView.numberOfRows(inSection: lastSectionIndex) - 1 else { return }
        
        onNewPageRequest?()
        spinner.startAnimating()

        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
}

private extension MortyView {
    func setupViewsAndConstraints() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func setupPrerequisites() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}
