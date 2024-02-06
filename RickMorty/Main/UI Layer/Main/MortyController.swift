//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    let rootView = MortyView()
    private var paginationInfo: MortyModelInfo
    
    init(nextPage: MortyModelInfo, production: Bool = true) {
        self.paginationInfo = nextPage
        super.init(nibName: nil, bundle: nil)
        
        guard production else { return }
        fetchTasks()
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
            fetchTasks()
        }
    }
}

extension MortyController {
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
    
    func setDataSource(dataSource: [MortyModelResult]) {
        rootView.setDataSource(dataSource: dataSource)
    }
}
