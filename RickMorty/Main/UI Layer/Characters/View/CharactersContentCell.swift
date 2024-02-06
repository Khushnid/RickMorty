//
//  CharactersContentCell.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import Kingfisher
import UIKit

class CharactersContentCell: UITableViewCell {
    private enum Constants {
        static let loaderImage = UIImage(named: "rick_and_morty_placeholder")
    }
    
    static let reuseID = String(describing: CharactersContentCell.self)
    
    private let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private let horizontalTitleStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.image = Constants.loaderImage
        horizontalTitleStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func setupContentData(data: CharactersModelResult) {
        selectionStyle = .none
        setupContent()
        
        if let url = data.image, let imageURL = URL(string: url) {
            image.kf.indicatorType = .activity
            image.kf.setImage(with: imageURL, placeholder: Constants.loaderImage)
        } else {
            image.image = Constants.loaderImage
        }
       
        if let name = data.name, state(name) {
            let characterName = labelGenerate(name, true)
            horizontalTitleStackView.addArrangedSubview(characterName)
            horizontalTitleStackView.setCustomSpacing(10, after: characterName)
        }
        
        horizontalTitleStackView.addArrangedSubview(labelGenerate(
            generateSpecsText(data: data))
        )

        if let location = data.location?.name, !location.isEmpty {
            horizontalTitleStackView.addArrangedSubview(labelGenerate("Location: \(location)"))
        }
    }
}

private extension CharactersContentCell {
    func setupContent() {
        contentView.addSubview(container)
        
        container.addSubview(image)
        container.addSubview(horizontalTitleStackView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            container.heightAnchor.constraint(greaterThanOrEqualToConstant: 164),
        
            image.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 8),
            image.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: 140),
            image.widthAnchor.constraint(equalToConstant: 140),
            
            horizontalTitleStackView.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8),
            horizontalTitleStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            horizontalTitleStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])
    }
    
    func generateSpecsText(data: CharactersModelResult) -> String {
        var specs = "Specs: "
        
        if let status = data.status, state(status) { specs += "\(status), " }
        if let species = data.species, state(species) { specs += "\(species), " }

        // MARK: - If you need to know type of the character, uncomment the line below
        // if let type = data.type, state(type) { specs += "\(type), " }
        
        if let gender = data.gender, state(gender) {
            specs += "\(gender) "
        } else {
            specs = String(specs.dropLast(2))
        }
        
        return specs
    }
    
    func state(_ text: String) -> Bool {
        !text.isEmpty && text != "unknown"
    }
    
    func labelGenerate(_ text: String, _ special: Bool = false) -> UILabel {
        let label = UILabel()
        label.font = special ? .boldSystemFont(ofSize: 14) : .systemFont(ofSize: 12)
        label.textColor = special ? .blue : .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
