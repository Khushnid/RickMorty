//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private var pageInfo: MortyModelInfo? = nil {
        didSet {
            
        }
    }
    
    private let rootView = MortyView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBinders()
        fetchCharacters()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        rootView.stopLoading()
    }
}

private extension MortyController {
    func setupBinders() {
        rootView.onNewPageRequest = { [weak self] in
            guard let self else { return }
            fetchCharacters(link: pageInfo?.next ?? "")
        }
    }
    
    func fetchCharacters(link: String = "") {
        rootView.startLoading()
        
        Task {
            do {
                // MARK: - Simulated thread sleep for a half second
                try await Task.sleep(nanoseconds: 2_000_000_000)
                handleResults(try await MortyManager.shared.fetchCharacter(link: link))
            } catch {
                rootView.stopLoading()
                
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    self.fetchCharacters()
                }
            }
        }
    }
    
    func handleResults(_ result: MortyModel) {
        rootView.stopLoading()
        pageInfo = result.info
        
        guard let results = result.results else { return }
        rootView.setDataSource(dataSource: results)
    }
}
