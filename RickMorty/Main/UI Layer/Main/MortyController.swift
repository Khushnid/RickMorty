//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private var nextPage = ""
    private let rootView = MortyView()
    
    override func loadView() {
        view = rootView
        rootView.setupMortyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        fetchCharacters()
    }
}

private extension MortyController {
    func setupController() {
        title = "Rick & Morty"
        
        rootView.onNewPageRequest = { [weak self] in
            self?.fetchCharacters()
        }
    }
    
    func fetchCharacters() {
        Task {
            do {
                let endPoint = nextPage.isEmpty ? MortyManager.charcterURL : nextPage
                let characters = try await MortyManager.shared.fetchCharacter(link: endPoint)
 
                nextPage = characters.info?.next ?? ""
                rootView.setDataSource(dataSource: characters.results ?? [])
            } catch {
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    self.fetchCharacters()
                }
            }
        }
    }
}
