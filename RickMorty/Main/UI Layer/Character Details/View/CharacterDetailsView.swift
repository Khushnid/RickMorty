//
//  CharacterDetailsView.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 07/02/24.
//

import UIKit

class CharacterDetailsView: UIView {
    private enum Constants {
        static let loaderImage = UIImage(named: "rick_and_morty_placeholder")
    }
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.kf.indicatorType = .activity
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()
    
    private let detailsTitleStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalCentering
        stack.alignment = .top
        stack.axis = .vertical
        stack.spacing = 24
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        setupViewAndContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupRootView(character: CharacterDetailsModel) {
        if let url = character.image, let imageURL = URL(string: url) {
            image.kf.indicatorType = .activity
            image.kf.setImage(with: imageURL, placeholder: Constants.loaderImage)
        } else {
            image.image = Constants.loaderImage
        }
        
        detailsTitleStackView.addArrangedSubview(labelGenerate(
            generateSpecsText(data: character))
        )
        
        if let location = character.origin?.name, !location.isEmpty {
            detailsTitleStackView.addArrangedSubview(labelGenerate("First seen in: \n\(location)"))
        }
        
        if let location = character.location?.name, !location.isEmpty {
            detailsTitleStackView.addArrangedSubview(labelGenerate("Last known location: \n\(location)"))
        }
    }
}

private extension CharacterDetailsView {
    func setupViewAndContraints() {
        addSubview(image)
        addSubview(detailsTitleStackView)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            image.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            image.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            image.heightAnchor.constraint(equalToConstant: 250),
            
            detailsTitleStackView.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 12),
            detailsTitleStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 8),
            detailsTitleStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8)
        ])
    }
    
    func generateSpecsText(data: CharacterDetailsModel) -> String {
        var specs = "Specs: \n"
        
        if let status = data.status, state(status) { specs += "\(status), " }
        if let species = data.species, state(species) { specs += "\(species), " }
        if let type = data.type, state(type) { specs += "\(type), " }
        
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
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.textColor = .white
        label.numberOfLines = 0
        label.text = text
        return label
    }
}
