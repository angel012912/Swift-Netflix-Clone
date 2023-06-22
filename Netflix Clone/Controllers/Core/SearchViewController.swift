//
//  SearchViewController.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 20/06/23.
//

import UIKit

class SearchViewController: UIViewController {
    // Se define el array de datos que se van a renderear y se inicializa vacio
    private var titles: [Title] = [Title]()
    // Se configura la tabla donde se van a renderear los datos
    private let discoverMoviesTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    // Se configura la barra de busqueda donde se va a ingresar la busqueda
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a Tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuracion basica de la pantalla
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        // Configuracion de la tabla
        view.addSubview(discoverMoviesTable)
        discoverMoviesTable.delegate = self
        discoverMoviesTable.dataSource = self
        // Descarga de datos
        fetchDiscoverMovies()
        // Se agrega la funcion que va a manejar la actualizacion de datos ingresados por el input de la barra de busqueda
        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Asignar un cuadro donde renderearse
        discoverMoviesTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovies(){
        // weak self es para evitar memory leak
        // Se obtienen los datos a renderear
        APICaller.shared.getDiscoverMovies{ [weak self]
            result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                // Se recarga la informacion de la tabla en el main thread
                DispatchQueue.main.async {
                    self?.discoverMoviesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// Se configura la tabla y las celdas a renderear
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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

// Se configura la funcion para la actualizacion del input de la barra de busqueda
extension SearchViewController: UISearchResultsUpdating {
    // Obtener el query de la barra de busqueda
    func updateSearchResults(for searchController: UISearchController) {
        // Se asigna la instancia de la barra de busqueda en una variable para un mejor manejo
        let searchBar = searchController.searchBar
        // Se obtiene el query siempre y cuando sea valido segun ciertos parametros
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        // Se hace la llamada a la funcion para realizar una busqueda por parametros
        APICaller.shared.search(with: query){ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResults.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
