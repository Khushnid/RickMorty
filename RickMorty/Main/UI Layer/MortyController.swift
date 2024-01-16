//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private var pageInfo: MortyModelInfo? = nil
    private let rootView = MortyView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
        fetchCharacters()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        loader(state: .stop)
    }
}

private extension MortyController {
    func setupController() {
        title = "Rick & Morty"
        
        rootView.onNewPageRequest = { [weak self] in
            guard let self, let nextURL = pageInfo?.next else { return }
            fetchCharacters(link: nextURL)
        }
    }
    
    func fetchCharacters(link: String = "") {
        loader(state: .start)
        
        Task {
            do {
                // MARK: - Simulated thread sleep
                try await Task.sleep(nanoseconds: 500_000_000)
                handleResults(try await MortyManager.shared.fetchCharacter(link: link))
            } catch {
                loader(state: .stop)
                
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    self.fetchCharacters()
                }
            }
        }
    }
    
    func handleResults(_ result: MortyModel) {
        loader(state: .stop)
        pageInfo = result.info
        
        guard let results = result.results else { return }
        rootView.setDataSource(dataSource: results)
    }
    
    func loader(state: LoaderState) {
        switch state {
       
        case .start:
            rootView.startLoading()
        
        case .stop:
            rootView.stopLoading()
        }
    }
}
