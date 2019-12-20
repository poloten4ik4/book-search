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
            guard let attr = layoutAttributesForItem(at: IndexPath(row: i, section: 0)),
                let newAttr = attr.copy() as? UICollectionViewLayoutAttributes else { continue }
            
            newAttr.center = centerForItemAt(index: i, itemsPerRow: itemsPerRow, spacing: spacing)
            attrs.append(newAttr)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrs
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attr = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath) else { return nil }
        let itemsPerRow = getItemsPerRow()
        let spacing = getSpacing(for: itemsPerRow)
        attr.center = centerForItemAt(index: itemIndexPath.row, itemsPerRow: itemsPerRow, spacing: spacing)
        attr.alpha = 1
        return attr
    }
    
    // MARK: - Private. Helpers
    
    private func getItemsPerRow() -> Int {
        guard let collection = collectionView else { return 0 }
        return Int(collection.bounds.width / itemSize.width)
    }
    
    private func getSpacing(for itemsPerRow: Int) -> CGFloat {
        guard let collection = collectionView else { return 0 }
        return (collection.bounds.width - CGFloat(itemsPerRow) * itemSize.width) / (CGFloat(itemsPerRow) + 1)
    }
    
    private func centerForItemAt(index: Int, itemsPerRow: Int, spacing: CGFloat) -> CGPoint {
        let row = index / itemsPerRow
        let column = index % itemsPerRow
        
        return CGPoint(x: spacing + CGFloat(column) * (spacing + itemSize.width) + itemSize.width / 2,
                       y: spacing + CGFloat(row) * (spacing + itemSize.height) + itemSize.height / 2)
    }
    
    func getCellSize() -> CGSize {
        guard let collection = collectionView else { return .zero }
        let width = collection.bounds.width
        let spacing: CGFloat = 16.0
        let cellWidth = (width - 3 * spacing) / 2
        return CGSize(width: cellWidth, height: 180)
    }
}
