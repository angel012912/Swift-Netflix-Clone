//
//  DataPersistanceManager.swift
//  Netflix Clone
//
//  Created by Angel Garcia on 22/06/23.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    
    enum DatabaseError: Error{
        case failedToSaveData
        case failedToRetrieveData
    }
    
    static let shared = DataPersistanceManager()
    
    func downloadTitle(model: Title, completion: @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.media_type = model.media_type
        item.original_language = model.original_language
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem> = TitleItem.fetchRequest()
        
        do{
            let titles = try context.fetch(request)
            completion(.success(titles))
        }catch{
            completion(.failure(DatabaseError.failedToRetrieveData))
        }
    }
}
