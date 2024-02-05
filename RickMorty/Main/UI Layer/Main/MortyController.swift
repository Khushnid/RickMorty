//
//  MortyController.swift
//  RickMorty
//
//  Created by Khushnidjon Keldiboev on 16/01/24.
//

import UIKit

class MortyController: UIViewController {
    let rootView = MortyView()
    private var paginationInfo: MortyModel.MortyModelInfo
    
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
            fetchTasks()
        }
        
        fetchTasks()
    }
}

extension MortyController {
    func fetchCharacters() async {
        do {
            guard let nextPageURL = paginationInfo.next else { return rootView.stopLoadItems() }
            let characters = try await MortyManager.shared.fetchCharacter(link: nextPageURL)
            
            setDataSource(dataSource: characters.results ?? [])
            paginationInfo = characters.info
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
    
    func setDataSource(dataSource: [MortyModel.MortyModelResult]) {
        rootView.setDataSource(dataSource: dataSource)
    }
}
