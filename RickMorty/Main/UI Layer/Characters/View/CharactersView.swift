//
//  CharactersView.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class CharactersView: UIView {
    var onNewPageRequest: (() -> Void)?
    var onCharacterSelected: ((Int) -> Void)?
    var dataSource: UITableViewDiffableDataSource<CharactersSection, CharactersModelResult>!
    var onRefresh: (() -> Void)?
    
    var networkDTO = [CharactersModelResult]() {
        didSet { applySnapshot() }
    }
    
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(CharactersContentCell.self, forCellReuseIdentifier: CharactersContentCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.delegate = self
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private(set) lazy var tableLoader: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.frame = CGRect(x: .zero, y: .zero, width: tableView.bounds.width, height: CGFloat(44))
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    func setDataSource(dataSource: [CharactersModelResult]) {
        networkDTO += dataSource
    }
    
    func setupRootView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        dataSource = UITableViewDiffableDataSource<CharactersSection, CharactersModelResult>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CharactersContentCell.reuseID) as? CharactersContentCell else {
                    return UITableViewCell()
                }
                
                guard let contentData = self.networkDTO[safe: indexPath.row] else { return cell }
                cell.setupContentData(data: contentData)
                return cell
            }
        )
        
        refreshControl.addTarget(self, action: #selector(refreshTriggered), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func stopLoadItems() {
        tableLoader.stopAnimating()
        tableView.tableFooterView?.isHidden = true
    }
    
    func stopRefresh() {
        refreshControl.endRefreshing()
    }
    
    @objc private func refreshTriggered() {
        onRefresh?()
    }
    
    private func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<CharactersSection, CharactersModelResult>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(networkDTO)
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension CharactersView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        guard indexPath.section == lastSectionIndex && indexPath.row == tableView.numberOfRows(inSection: lastSectionIndex) - 1 else { return }
        
        onNewPageRequest?()
        tableLoader.startAnimating()
        
        tableView.tableFooterView = tableLoader
        tableView.tableFooterView?.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = networkDTO[safe: indexPath.row], let characterID = dataSource.id else { return }
        onCharacterSelected?(characterID)
    }
}
