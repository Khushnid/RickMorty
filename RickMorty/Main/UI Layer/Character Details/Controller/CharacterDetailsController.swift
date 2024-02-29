//
//  CharacterDetailsController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import UIKit
import Kingfisher

class CharacterDetailsController: UIViewController {
    private let networkManager = MortyManager()
    let rootView = CharacterDetailsView()
    let characterID: UInt
    
    init(characterID: UInt) {
        self.characterID = characterID
        super.init(nibName: nil, bundle: nil)
        
        fetchTasks()
    }
    
    var character: CharacterDetailsModel? = nil {
        didSet {
            guard let character else { return }
            rootView.setupRootView(character: character)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
    }
}

extension CharacterDetailsController {
    func fetchCharactersDetails(onComplete: @escaping () async throws -> Void = {}) async {
        do {
            character = try await networkManager.fetchCharacterDetails(characterID: characterID)
            title = character?.name
            try await onComplete()
        } catch {
            showAlert(title: "Error occured", message: error.localizedDescription) { [weak self] in
                guard let self else { return }
                fetchTasks()
            }
        }
    }
}

private extension CharacterDetailsController {
    func fetchTasks() {
        Task { await fetchCharactersDetails() }
    }
}
