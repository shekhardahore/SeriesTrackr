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
    
    //Saves show
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
                print(error)
            }
        }
    }
    
    //Checks for duplicates
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
    
    //Returns all the shows
    func getShowList(completion: @escaping ParseServiceCompletion<[TVShow]>) {
        let query = PFQuery(className:ParseClassNames.tvShow)
        query.cachePolicy = .cacheThenNetwork
        query.findObjectsInBackground { (data, error) in
            guard error == nil else {
                if error?._code == PFErrorCode.errorObjectNotFound.rawValue {
                    completion(.failure(.noDataFound))
                } else if error?._code == PFErrorCode.errorConnectionFailed.rawValue {
                    completion(.failure(.requestFailed))
                } else {
                    let errorString = error?._userInfo!["error"] as? NSString
                    print("Error: \(errorString ?? "")")
                    completion(.failure(.unknown))
                }
                return
            }
            guard let data = data else {
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
    
    func checkIfShowExists(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        //        beforeSave(show: show) { result in
        //            completion(result)
        //        }
    }
}
