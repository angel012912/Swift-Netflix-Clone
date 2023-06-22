//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 20/06/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadedMoviesTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(downloadedMoviesTable)
        
        downloadedMoviesTable.delegate = self
        downloadedMoviesTable.dataSource = self
        
        fetchLocalStorageForDownloadedTitles()
    }
    
    private func fetchLocalStorageForDownloadedTitles(){
        DataPersistanceManager.shared.fetchTitlesFromDataBase {[weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                self?.downloadedMoviesTable.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadedMoviesTable.frame = view.bounds
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier ,for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? "Unkown Title", posterUrl: title.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}
