//
//  Home.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 20/06/23.
// 

import UIKit

enum Sections : Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case PopularMovies = 2
    case UpcomingMovies = 3
    case TopRatedMovies = 4
}

class HomeViewController: UIViewController {
    
    private var randomHeaderMovie: Title?
    
    private var headerView: HeroHeaderUIView?
    
    // Lista de encabezado de las secciones
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top Rated"]
 
    // Se define una tabla y se configura usando un patron de cerrado anonimo -> {}()
    private let homeFeedTable: UITableView = {
        // Se inicializa la tabla
        let table = UITableView(frame: .zero, style: .grouped)
        // Se registra una celda normal por ahora -> Posteriormente se va a personalizar
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        // Se regresa la tabla ya instanciada
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Se asigna el color de fondo al que tenga el sistema
        view.backgroundColor = .systemBackground
        // Se agrega a la vista la tabla creada previamente
        view.addSubview(homeFeedTable)
        
        
        // Se asignan valores a las celdas
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        
        // Configurar el header
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
    }
    
    // Se sobre escribe la funcion de cuando la vista renderea las sub-vistas
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Se asigna un  cuadro para poder verlo en la pantalla
        // view.bounds -> Se establece que cubra todos los limites de la pantalla
        homeFeedTable.frame = view.bounds
    }
    
    private func configureHeroHeaderView(){
        APICaller.shared.getTrendingMovies{ [weak self] result in
            switch result{
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomHeaderMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterUrl: selectedTitle?.poster_path ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar(){
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Se definen la cantidad de secciones
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    // Se definen la cantidad de renglones por seccion
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Se define el estilo de la celda por renglon
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.PopularMovies.rawValue:
            APICaller.shared.getPopularMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.UpcomingMovies.rawValue:
            APICaller.shared.getUpcomingMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        case Sections.TopRatedMovies.rawValue:
            APICaller.shared.getTopRatedMovies {
                result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error)
                }
            }
        default:
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        return cell
    }
    
    // Se define el tamaño del renflon
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // Se define el tamaño del header de la seccion
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func CollectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
