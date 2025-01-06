//
//  CharactersController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class CharactersController: UIViewController {
    let rootView = CharactersView()
    private var paginationInfo: CharactersModelInfo
    private let networkManager = MortyManager()
    
    init(nextPage: CharactersModelInfo, production: Bool = true) {
        self.paginationInfo = nextPage
        super.init(nibName: nil, bundle: nil)
        
        title = "Rick & Morty"
        setupViewBinders()

        guard production else { return }
        fetchTasks()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
        rootView.setupRootView()
    }
}

extension CharactersController {
    func fetchCharacters(onComplete: @escaping () async throws -> Void = {}) async {
        do {
            guard let nextPageURL = paginationInfo.next else { return rootView.stopLoadItems() }
            let characters = try await networkManager.fetchCharacter(link: nextPageURL)
            
            setDataSource(dataSource: characters.results ?? [])
            paginationInfo = characters.info
            try await onComplete()
        } catch {
            showAlert(title: "Error occured", message: error.localizedDescription) { [weak self] in
                guard let self else { return }
                fetchTasks()
            }
        }
    }
    
    func setDataSource(dataSource: [CharactersModelResult]) {
        rootView.setDataSource(dataSource: dataSource)
    }
}

private extension CharactersController {
    func setupViewBinders() {
        rootView.onNewPageRequest = { [weak self] in
            guard let self else { return }
            fetchTasks()
        }
        
        rootView.onCharacterSelected = { [weak self] characterID in
            guard let self else { return }
            onCharacterDetailsRequest(with: UInt(characterID))
        }
        
        rootView.onRefresh = { [weak self] in
            guard let self else { return }
            fetchTasks()
        }
    }
    
    func fetchTasks() {
        rootView.stopRefresh()
        Task { await fetchCharacters() }
    }
    
    func onCharacterDetailsRequest(with id: UInt) {
        let characterDetailsVC = CharacterDetailsController(characterID: id)
        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }
}
