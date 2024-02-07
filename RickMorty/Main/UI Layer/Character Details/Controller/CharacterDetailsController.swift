//
//  CharacterDetailsController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 06/02/24.
//

import UIKit

class CharacterDetailsController: UIViewController {
    let rootView = CharacterDetailsView()
    let characterID: UInt
    
    init(characterID: UInt) {
        self.characterID = characterID
        super.init(nibName: nil, bundle: nil)
        
        fetchTasks()
    }
    
    var character: CharacterDetailsModel? = nil {
        didSet {
            dump(character)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
        rootView.setupRootView()
    }
}

extension CharacterDetailsController {
    func fetchCharactersDetails(onComplete: @escaping () async throws -> Void = {}) async {
        do {
            character = try await MortyManager.shared.fetchCharacterDetails(characterID: characterID)
            try await onComplete()
        } catch {
            showAlert(title: "Error occured", message: error.localizedDescription) { [weak self] in
                guard let self else { return }
                fetchTasks()
            }
        }
    }
    
    func fetchTasks() {
        Task { await fetchCharactersDetails() }
    }
}
