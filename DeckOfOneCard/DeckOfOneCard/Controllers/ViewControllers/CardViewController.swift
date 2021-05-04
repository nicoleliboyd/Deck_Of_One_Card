//
//  CardViewController.swift
//  DeckOfOneCard
//
//  Created by David Boyd on 5/4/21.
//

import UIKit

class CardViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Actions
    @IBAction func drawButtonTapped(_ sender: Any) {
        CardController.fetchCard {[weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let card):
                    self?.fetchImageAndUpdateViews(for: card)
                    
                case .failure(let error):
                    self?.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
    
    //MARK: - Functions
    
    func fetchImageAndUpdateViews(for card: Card) {

      CardController.fetchImage(for: card) { [weak self] result in
        DispatchQueue.main.async {
            switch result {
                case .success(let image):
                  self?.cardTitleLabel.text = "\(card.value) of \(card.suit)"
                  self?.cardImageView.image = image
              
                case .failure(let error):
                  self?.presentErrorToUser(localizedError: error)
                }
        }
      }
    }

}//End of class
