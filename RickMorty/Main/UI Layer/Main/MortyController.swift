//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    private var paginationInfo: MortyModel.MortyModelInfo
    private let rootView = MortyView()
    
    init(nextPage: MortyModel.MortyModelInfo) {
        self.paginationInfo = nextPage
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
}

private extension MortyController {
    func fetchCharacters() {
        Task {
            do {
                guard let nextPageURL = paginationInfo.next else { return rootView.stopLoadItems() }
                let characters = try await MortyManager.shared.fetchCharacter(link: nextPageURL)
                
                setDataSource(dataSource: characters.results ?? [])
                paginationInfo = characters.info
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
