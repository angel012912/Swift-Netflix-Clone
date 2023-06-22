//
//  SearchResultsViewController.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 21/06/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func SearchResultsViewControllerDidTapItem(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    public weak var delegate: SearchResultsViewControllerDelegate?
    // Se define el array de datos que se van a renderear y se inicializa vacio
    public var titles: [Title] = [Title]()
    // Se configura la coleccion de la vista que se usará
    public let searchResults: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 16, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Se configura la pantall
        view.backgroundColor = .systemBackground
        view.addSubview(searchResults)
        // Se configura la colleccion de vistas
        searchResults.delegate = self
        searchResults.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Se le asigna un cuadro donde renderearse
        searchResults.frame = view.bounds
    }
}

// Configuracion de la vista de los datos de titles
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell()}
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? ""
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultsViewControllerDidTapItem(TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverView: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
