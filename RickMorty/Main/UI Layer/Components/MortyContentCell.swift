//
//  MortyContentCell.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyContentCell: UITableViewCell {
    static let reuseID = String(describing: MortyContentCell.self)
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .blue
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setupContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupContent() {
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            container.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupContentData(data: MortyModelResult) {
        
    }
}
