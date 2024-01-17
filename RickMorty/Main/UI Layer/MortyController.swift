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
            guard let self, !nextPage.isEmpty else { return }
            fetchCharacters(link: nextPage)
        }
    }
    
    func fetchCharacters(link: String = "") {
        Task {
            do {
                // MARK: - Simulated thread sleep
                try await Task.sleep(nanoseconds: 300_000_000)
                handleResults(try await MortyManager.shared.fetchCharacter(link: link))
            } catch {
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    self.fetchCharacters()
                }
            }
        }
    }
    
    func handleResults(_ result: MortyModel) {
        nextPage = result.info?.next ?? ""
        
        guard let results = result.results else { return }
        rootView.setDataSource(dataSource: results)
    }
}
