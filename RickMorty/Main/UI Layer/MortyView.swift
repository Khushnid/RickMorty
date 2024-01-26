//
//  MortyView.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyView: UIView {
    var onNewPageRequest: (() -> Void)?
    
    enum MortySection {
        case main
    }
    
    var dataSource: UITableViewDiffableDataSource<MortySection, MortyHashed>!
    
    private var networkDTO = [MortyModelResult]() {
        didSet {
            applySnapshot()
        }
    }
    
    private(set) lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(MortyContentCell.self, forCellReuseIdentifier: MortyContentCell.reuseID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.delegate = self
        return table
    }()
    
    func setDataSource(dataSource: [MortyModelResult]) {
        self.networkDTO += dataSource
    }
    
    func setupMortyView() {
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        dataSource = UITableViewDiffableDataSource<MortySection, MortyHashed>(
            tableView: tableView,
            cellProvider: { tableView, indexPath, itemIdentifier in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MortyContentCell.reuseID) as? MortyContentCell else {
                    return UITableViewCell()
                }
                
                guard let contentData = self.networkDTO[safe: indexPath.row] else { return cell }
                cell.setupContentData(data: contentData)
                return cell
            }
        )
    }
    
    func applySnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<MortySection, MortyHashed>()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(networkDTO.compactMap { MortyHashed($0) } )
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

extension MortyView: UITableViewDelegate {
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
