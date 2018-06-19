//
//  ProductListCollectionViewCell.swift
//  JohnLewis
//
//  Created by Callum Boddy on 19/06/2018.
//  Copyright © 2018 Callum Boddy. All rights reserved.
//

import UIKit
import Kingfisher


/// respresnets the cell subclass used by the ProductListViewController, has associated prototype cell ProductListViewController storyboard
class ProductListCollectionViewCell: UICollectionViewCell {

    // MARK - Instace Variables

    static let reuseIdentifier = "ProductListCollectionViewCell"

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!

    private var state: State = State.empty

    // MARK - State

    struct State {
        let imageURL: URL?
        let title: String
        let price: String

        static let empty = State(imageURL: nil, title: "", price: "")
    }

    // MARK - Public Interface

    func render(state: State, animated: Bool = false) {
        self.state = state
        imageView.kf.setImage(with: state.imageURL)
        titleLabel.text = state.title
        priceLabel.text = "£\(state.price)"
    }
}
