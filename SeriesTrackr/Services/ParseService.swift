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
        checkForDuplicate(show: show) { result in
            switch result{
            case .success(let isDuplicate):
                if !isDuplicate {
                    show.saveInBackground { (success, error) in
                        if success {
                            completion(.success(true))
                        } else {
                            print(error?.localizedDescription ?? "")
                            completion(.failure(.requestFailed))
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
    private func checkForDuplicate(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        let query = PFQuery(className: ParseClassNames.tvShow)
        query.whereKey(ParseObjectKeys.showId, equalTo: show.showId)
        query.getFirstObjectInBackground { (show, error) in
            if let _ = show {
                print("Everything went fine!")
                completion(.success(true))
            } else {
                if let error = error {
                    if error._code == PFErrorCode.errorObjectNotFound.rawValue {
                        print("Uh oh, we couldn't find the object!")
                        completion(.success(false))
                    } else if error._code == PFErrorCode.errorConnectionFailed.rawValue {
                        completion(.failure(.requestFailed))
                        print("Uh oh, we couldn't even connect to the Parse Cloud!")
                    } else {
                        let errorString = error._userInfo!["error"] as? NSString
                        print("Error: \(errorString ?? "")")
                        completion(.failure(.unknown))
                    }
                }
            }
        }
    }
    
    //Returns all the shows
    func getShowList(completion: @escaping ParseServiceCompletion<[PFObject]>) {
        let query = PFQuery(className:ParseClassNames.tvShow)
        query.findObjectsInBackground { (data, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                completion(.failure(.unknown))
                return
            }
            guard let shows = data else {
                completion(.failure(.noDataFound))
                return
            }
            print("data retived")
            completion(.success(shows))
        }
    }
    
    func checkIfShowExists(show: TVShow, completion: @escaping ParseServiceCompletion<Bool>) {
        //        beforeSave(show: show) { result in
        //            completion(result)
        //        }
    }
}
