//
//  BookCell.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 19/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

enum WishListOperationType {
    case add
    case remove
}

enum BookCellInteractionType {
    case wishList(WishListOperationType)
    case main
}

class BookCell: UICollectionViewCell, ReusableView {
    
    private enum Constants {
        static let cornerRadius: CGFloat = 5
        static let shadowRadius: CGFloat = 5
        static let defaultHeight: CGFloat = 180
        static let spacing: CGFloat = 8
        static let infoHeight: CGFloat = 60
        static let buttonSize = CGSize(width: 30, height: 30)
        static let inset: CGFloat = 8
    }
    
    var onTap: ((BookCellInteractionType) -> ())?
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = UIColor.warmGrayColor
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 3
        return label
    }()
    
    func configure(_ viewModel: BookCellViewModel) {
        titleLabel.text = viewModel.titleWithAuthor
        let placeholderImage = UIImage(named: viewModel.imagePlaceholderName)
        imageView.kf.setImage(with: viewModel.imageURL, placeholder: placeholderImage, options: [.transition(.fade(0.3))])
    }
    
    
    // TODO: Add actions
    func addToWishList() {
        onTap?(.wishList(.add))
    }
  
    // MARK: - Override
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        button.frame = CGRect(x: contentView.bounds.width - Constants.buttonSize.width - Constants.inset,
                              y: contentView.bounds.height - Constants.infoHeight / 2 - Constants.buttonSize.height / 2,
                              width: Constants.buttonSize.width,
                              height: Constants.buttonSize.height)
        
        titleLabel.frame = CGRect(x: Constants.inset,
                                  y: contentView.bounds.height - Constants.infoHeight,
                                  width: contentView.bounds.width - 2 * Constants.inset - Constants.buttonSize.width - Constants.spacing,
                                  height: Constants.infoHeight)
        
        imageView.frame = CGRect(x: 0,
                                 y: 0,
                                 width: contentView.bounds.width,
                                 height: contentView.bounds.height - Constants.infoHeight)
        
        (contentView.layer.mask as? CAShapeLayer)?.path = UIBezierPath(roundedRect: contentView.bounds,
                                                                       cornerRadius: Constants.cornerRadius).cgPath
        
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds,
                                        cornerRadius: Constants.cornerRadius).cgPath
    }
    
    // MARK: - Private. Setup
    
    private func setup() {
        contentView.backgroundColor = .white
    
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(button)
        
        contentView.layer.mask = CAShapeLayer()
        
        setupShadow()
    }
    
    private func setupShadow() {
        layer.shadowOpacity = 0.15
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = Constants.shadowRadius
    }
}

// MARK: - Height

extension BookCell {
    static var height: CGFloat {
        return Constants.defaultHeight
    }
}
