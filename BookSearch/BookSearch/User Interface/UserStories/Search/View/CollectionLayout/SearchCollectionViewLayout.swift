//
//  SearchCollectionViewLayout.swift
//  BookSearch
//
//  Created by Zaslavskiy Mike on 19/12/2019.
//  Copyright © 2019 MikeZaslavskiy. All rights reserved.
//

import UIKit

final class SearchCollectionLayout: UICollectionViewFlowLayout {
    
    var attrs: [UICollectionViewLayoutAttributes] = []
    
    // MARK: - Override
    
    override var collectionViewContentSize: CGSize {
        guard let collection = collectionView else { return .zero }
        
        let number = collection.numberOfItems(inSection: 0)
        let itemsPerRow = getItemsPerRow()
        let spacing = getSpacing(for: itemsPerRow)
        
        let rows = number / itemsPerRow + (number % itemsPerRow > 0 ? 1 : 0)
        
        return CGSize(width: collection.bounds.width,
                      height: CGFloat(rows) * (itemSize.height + spacing) + spacing)
    }
    
    override func prepare() {
        super.prepare()
        
        attrs = []
        
        guard let collection = collectionView else { return }
        
        let number = collection.numberOfItems(inSection: 0)
        let itemsPerRow = getItemsPerRow()
        let spacing = getSpacing(for: itemsPerRow)
        
        for i in 0..<number {
            let row = i / itemsPerRow
            let column = i % itemsPerRow
            
            guard let attr = layoutAttributesForItem(at: IndexPath(row: i, section: 0)) else { continue }
            
            attr.center = CGPoint(x: spacing + CGFloat(column) * (spacing + itemSize.width) + itemSize.width / 2,
                                  y: spacing + CGFloat(row) * (spacing + itemSize.height) + itemSize.height / 2)
            
            attrs.append(attr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    // MARK: - Private. Helpers
    
    func getItemsPerRow() -> Int {
        guard let collection = collectionView else { return 0 }
        return Int(collection.bounds.width / itemSize.width)
    }
    
    func getSpacing(for itemsPerRow: Int) -> CGFloat {
        guard let collection = collectionView else { return 0 }
        return (collection.bounds.width - CGFloat(itemsPerRow) * itemSize.width) / (CGFloat(itemsPerRow) + 1)
    }
}
