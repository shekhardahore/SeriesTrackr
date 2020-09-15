//
//  ParseService.swift
//  SeriesTrackr
//
//  Created by Shekhar Dahore on 12/09/20.
//  Copyright © 2020 shek. All rights reserved.
//

import Foundation
import Parse

class ParseService {
    
    typealias ParseServiceCompletion<T> = (Result<T, NetworkError>) -> Void
    
    /// Save show on parse. Checks for duplicates before saving
    ///
    /// - Parameters:
    ///   - show: TV Show to save
    ///   - completion: returns `True` on successful save. `NetworkError` on failure.
    func save(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        tvShowAlreadyExists(show: show) { result in
            switch result{
            case .success(let isDuplicate):
                if !isDuplicate {
                    show.saveInBackground { (success, error) in
                        if success {
                            completion(.success(true))
                        } else {
                            if error?._code == PFErrorCode.errorConnectionFailed.rawValue {
                                completion(.failure(.requestFailed))
                            } else {
                                let errorString = error?._userInfo!["error"] as? NSString
                                print("Error: \(errorString ?? "")")
                                completion(.failure(.unknown))
                            }
                        }
                    }
                } else {
                    completion(.failure(.duplicateShow))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    ///Checks for duplicates.
    private func tvShowAlreadyExists(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        let query = PFQuery(className: ParseClassNames.tvShow)
        query.whereKey(ParseObjectKeys.showId, equalTo: show.showId)
        query.getFirstObjectInBackground { (show, error) in
            guard let _ = show else {
                if error?._code == PFErrorCode.errorObjectNotFound.rawValue {
                    //TV show not found
                    completion(.success(false))
                } else if error?._code == PFErrorCode.errorConnectionFailed.rawValue {
                    completion(.failure(.requestFailed))
                } else {
                    let errorString = error?._userInfo!["error"] as? NSString
                    print("Error: \(errorString ?? "")")
                    completion(.failure(.unknown))
                }
                return
            }
            //TV show already exists
            completion(.success(true))
        }
    }
    
    /// Gets the list of all the TV shows on Parse
    ///
    /// - Parameters:
    ///   - completion: returns `[TVShow]` on success. `NetworkError` on failure.
    func getShowList(completion: @escaping ParseServiceCompletion<[TVShow]>) {
        let query = PFQuery(className:ParseClassNames.tvShow)
        query.cachePolicy = .cacheThenNetwork
        query.findObjectsInBackground { (data, error) in
            guard error == nil else {
                if error?._code == PFErrorCode.errorObjectNotFound.rawValue {
                    completion(.failure(.noDataFound))
                } else if error?._code == PFErrorCode.errorConnectionFailed.rawValue {
                    completion(.failure(.requestFailed))
                } else if error?._code == PFErrorCode.errorCacheMiss.rawValue {
                    completion(.failure(.cacheMiss))
                } else {
                    let errorString = error?._userInfo!["error"] as? NSString
                    print("Error: \(errorString ?? "")")
                    completion(.failure(.unknown))
                }
                return
            }
            guard let data = data, data.count > 0 else {
                PFQuery.clearAllCachedResults()
                completion(.failure(.noDataFound))
                return
            }
            var shows: [TVShow] = []
            for show in data {
                shows.append(show as! TVShow)
            }
            completion(.success(shows))
        }
    }
     
    /// Deletes the given show.
    ///
    /// - Parameters:
    ///   - show: TV Show to delete.
    ///   - completion: returns `True` on successful save. `NetworkError.unknown` on failure.
    func delete(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        show.deleteInBackground { (success, error) in
            if error != nil || !success {
                completion(.failure(.unknown))
            } else {
                PFQuery.clearAllCachedResults()
                completion(.success(true))
            }
        }
    }
    
    /// Updates the `watchStatus` for the show.
    ///
    /// - Parameters:
    ///   - show: TV Show to update with the updated `watchStatus`.
    ///   - completion: returns `True` on successful save. `NetworkError.unknown` on failure.
    func update(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        show.saveInBackground { (success, error) in
            if error != nil || !success {
                completion(.failure(.unknown))
            } else {
                PFQuery.clearAllCachedResults()
                completion(.success(true))
            }
        }
    }
}
