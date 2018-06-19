//
//  SearchClient.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import Foundation


/// search api completion with contains a generic Result object of type SearchProduct
typealias SearchCompletion = (_ result: Result<[SearchProduct]>) -> ()


/// typealis for search query to be used publically
typealias SearchQuery = SearchCient.Query


/// enumerator to track errors form the search api
///
/// - error: fallback generic error of least specificity
enum SearchError: Error {
    case invalidEndpoint
    case incompatableURL
    case invalidData
    case error

    //TODO: add more search error cases and handle appropriately
}

/// the search client in an HTTP api client from interacting with the john lewis search api. This is an authentiated client
class SearchCient: AuthenicatedClient {

    // MARK - Instance Variables

    let session: URLSession
    let endpoint: String

    // MARK - Initialisers

    // TODO: extract constants elsewhere
    init(session: URLSession = URLSession.shared, endpoint: String = "https://api.johnlewis.com/v1/products/search") {
        self.session = session
        self.endpoint = endpoint
    }

    struct Query {
        let term: String
        let pageSize: Int = 20
    }

    /// communcates with the search api given a query asyncronously and will return a completion with SearchProducts or an Error
    ///
    /// - Parameters:
    ///   - query: a query contains a search term (e.g "dishwashers") and a pageSize (defaults to 20 items)
    ///   - completion: a generic Result object which contains and array of SearchProduct or an Error
    func fetch(matching query: Query, completion: @escaping SearchCompletion) {

        guard var urlComponenents = URLComponents(string: endpoint) else {
            completion(.failure(SearchError.invalidEndpoint))
            return
        }

        // create query items
        // TODO: extract to a generic helper function
        urlComponenents.queryItems = [
            URLQueryItem(name: "q", value: query.term),
            URLQueryItem(name: "key", value: apiKey()),
            URLQueryItem(name: "pageSize", value: "\(query.pageSize)")
        ]

        guard let url = urlComponenents.url else {
            completion(.failure(SearchError.incompatableURL))
            return
        }

        // create and start task with url session
        session.dataTask(with: URLRequest(url: url)) { (data, response, error) in

            // ensure valid data
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(SearchError.invalidData))
                    return
                }
                return
            }

            // ensure no error present
            if let _ = error {
                completion(.failure(SearchError.error))
                return
            }

            // parse data & create SearchProduct objects
            let searchProducts: [SearchProduct] = Parser.from(data: data, key: "products")

            // return products, executed on the main thread (possibly parameterise this an option in the future)
            DispatchQueue.main.async { completion(.success(searchProducts)) }
        }.resume()
    }
}

