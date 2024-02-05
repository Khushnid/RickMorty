//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private let rootView = MortyView()
    private var nextPage: String
    
    init(nextPage: String) {
        self.nextPage = nextPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
        rootView.setupMortyView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Rick & Morty"
        
        rootView.onNewPageRequest = { [weak self] in
            guard let self else { return }
            fetchCharacters()
        }
        
        fetchCharacters()
    }
    
    func fetchCharacters() {
        Task {
            do {
                let characters = try await MortyManager.shared.fetchCharacter(link: nextPage)
                guard let nextPageURL = characters.info?.next, nextPage != nextPageURL else { return rootView.stopLoadItems() }

                setDataSource(dataSource: characters.results ?? [])
                nextPage = nextPageURL
            } catch {
                showAlert(title: "Error occured", message: error.localizedDescription) {
                    self.fetchCharacters()
                }
            }
        }
    }
    
    func setDataSource(dataSource: [MortyModel.MortyModelResult]) {
        rootView.setDataSource(dataSource: dataSource)
    }
}
