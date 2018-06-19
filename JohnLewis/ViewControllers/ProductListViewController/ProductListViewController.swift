//
//  ProductListViewController.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import UIKit


/// respresnets the view controller class do display a grid view of the products given a search term, has associated storyboard of same name.
class ProductListViewController: UIViewController {

    // MARK - Instance Variables

    @IBOutlet var collectionView: UICollectionView!

    private(set) var state: State = State.empty {
        didSet {
            // update the title with the count of products returned from the server
            self.title = "\(state.query.term) (\(state.products.count))"
            collectionView.reloadData()
        }
    }

    // MARK - State

    struct State {
        let query: SearchQuery
        let products: [SearchProduct]

        static let empty = State(query: SearchQuery(term: ""), products: [])
    }

    // MARK - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // create search client
        let client = SearchCient()

        // hardcoded term for test purposes (can be manipulated and return accurate John Lewis api results)
        let query = SearchQuery(term: "Dishwashers")

        // set viewControler title
        title = query.term

        // perform fetch on search client & reloadData on networking completion
        client.fetch(matching: query) { (result) in
            if let products = try? result.value() {
                let state = State(query: query, products: products)
                self.state = state
            }
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return state.products.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductListCollectionViewCell else {
            fatalError("shiiiiit")
        }

        // populate cell with product data

        let product: SearchProduct = self.state.products[indexPath.row]
        let state = ProductListCollectionViewCell.State(imageURL: product.imageURL, title: product.title, price: product.price.now)
        cell.render(state: state)

        return cell
    }

}

extension ProductListViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        // cell calculation variables
        let shortesetSide = min(view.frame.size.width, view.frame.size.height)
        let potraitColumns = 3
        let potraitGaps = potraitColumns - 1

        // calculated cell width
        let width = (shortesetSide / CGFloat(potraitColumns)) - CGFloat(potraitGaps)

        // width is 3/4 of height.
        return CGSize(width: width, height: (width / 3) * 4)
    }

}

