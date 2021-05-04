//
//  CardController.swift
//  DeckOfOneCard
//
//  Created by David Boyd on 5/4/21.
//

import UIKit

class CardController {
    
    //reference: https://deckofcardsapi.com/api/deck/new/draw/?count=1
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck/new/draw/")
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = self.baseURL else {return completion(.failure(.invalidURL))}
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let urlParameter = ["count" : "1"]
        let qureyItems = urlParameter.compactMap( {URLQueryItem(name: $0.key, value: $0.value)})
        urlComponents?.queryItems = qureyItems
        guard let finalURL = urlComponents?.url else {return completion(.failure(.invalidURL))}
        print(finalURL)
        
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            // 3 - Handle errors from the server
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }

            // 4 - Check for json data
            guard let data = data else {return completion(.failure(.noData))}
            
            // 5 - Decode json into a Card
            do {
                let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = topLevelObject.cards.first else {return completion(.failure(.unableToDecode))}
                completion(.success(card))
            } catch {
                completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {

      // 1 - Prepare URL
        let url = card.image
        
      // 2 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            // 3 - Handle errors from the server
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            // 4 - Check for image data
            guard let data = data else {return completion(.failure(.noData))}
              
            // 5 - Initialize an image from the data
            guard let image = UIImage(data: data) else {return completion(.failure(.unableToDecode))}
            completion(.success(image))
        }.resume()
    }
    
    
}//End of class
