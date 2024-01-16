//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private let rootView = MortyView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCharacters()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        rootView.stopLoading()
    }
}

private extension MortyController {
    func fetchCharacters() {
        rootView.startLoading()
        
        Task {
            do {
                try await Task.sleep(nanoseconds: 1_000_000_000)
                let results = try await MortyManager.shared.fetchCharacter()
                handleResults(results)
            } catch {
                rootView.stopLoading()
                
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    // TODO: - Add retry strategy logic here
                }
            }
        }
    }
    
    func handleResults(_ results: [MortyModelResult]?) {
        rootView.stopLoading()
        
        guard let results else { return }
        rootView.setDataSource(dataSource: results)
    }
}
