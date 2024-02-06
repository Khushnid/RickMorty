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
    
    init(nextPage: CharactersModelInfo, production: Bool = true) {
        self.paginationInfo = nextPage
        super.init(nibName: nil, bundle: nil)
        
        title = "Rick & Morty"
        
        rootView.onNewPageRequest = { [weak self] in
            guard let self else { return }
            fetchTasks()
        }
        
        guard production else { return }
        fetchTasks()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
        rootView.setupCharactersView()
    }
}

extension CharactersController {
    func fetchCharacters(onComplete: @escaping () async throws -> Void = {}) async {
        do {
            guard let nextPageURL = paginationInfo.next else { return rootView.stopLoadItems() }
            let characters = try await MortyManager.shared.fetchCharacter(link: nextPageURL)
            
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
    
    func fetchTasks() {
        Task { await fetchCharacters() }
    }
    
    func setDataSource(dataSource: [CharactersModelResult]) {
        rootView.setDataSource(dataSource: dataSource)
    }
}
