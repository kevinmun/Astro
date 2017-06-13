//
//  ScheduleCollectionViewLayout.swift
//  Astro
//
//  Created by Kevin Mun on 13/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import UIKit

class ScheduleCollectionViewLayout: UICollectionViewLayout {
    let columnWidth = 100
    let numberOfColumns = 24 // 24 columns for 24 hours
    var itemAttributes: NSMutableArray!
    var itemsSize : [CGSize]!
    var contentSize: CGSize!
    
    
    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        let numberOfSections = collectionView.numberOfSections;
        if numberOfSections == 0 {
           return
        }
        
        //configure sticky top headers and leftmost rows
        if let itemAttributes = itemAttributes, itemAttributes.count > 0 {
            for section in 0..<numberOfSections {
                let numberOfItems = collectionView.numberOfItems(inSection: section)
                for index in 0..<numberOfItems {
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    if let attributes = layoutAttributesForItem(at: IndexPath(item: index, section: section)) {
                        if section == 0 {
                            var frame = attributes.frame
                            frame.origin.y = collectionView.contentOffset.y
                            attributes.frame = frame
                        }
                        
                        if index == 0 {
                            var frame = attributes.frame
                            frame.origin.x = collectionView.contentOffset.x
                            attributes.frame = frame
                        }
                    }
                }
            }
            return
        }
        
        //calculate items size only when not calculated or columns has changed
        if (itemsSize == nil || itemsSize.count != numberOfColumns) {
            calculateItemsSize()
        }
        
        var column = 0
        var xOffset: CGFloat = 0
        var yOffset: CGFloat = 0
        var contentWidth: CGFloat = 0
        var contentHeight: CGFloat = 0
        
        for section in 0..<numberOfSections {
            let sectionAttributes = NSMutableArray()
            
            for index in 0..<numberOfColumns {
                let itemSize = itemsSize[index]
                let indexPath = IndexPath(item: index, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height).integral
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024
                } else if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = collectionView.contentOffset.y
                    attributes.frame = frame
                }
                
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = collectionView.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.add(attributes)
                
                xOffset += itemSize.width
                column += 1
                
                if column == numberOfColumns {
                    if xOffset > contentWidth {
                        contentWidth = xOffset
                    }
                    
                    column = 0
                    xOffset = 0
                    yOffset += itemSize.height
                }
            }
            
            if itemAttributes == nil {
                itemAttributes = NSMutableArray(capacity: numberOfSections)
            }
            itemAttributes.add(sectionAttributes)
        }
        
        let lastSectionAtt = itemAttributes.lastObject as! NSMutableArray
        let attributes = lastSectionAtt.lastObject as! UICollectionViewLayoutAttributes
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let sectionAttributes = itemAttributes[indexPath.section] as! NSMutableArray
        return sectionAttributes[indexPath.row] as? UICollectionViewLayoutAttributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        if itemAttributes != nil {
            for case let section as NSMutableArray in itemAttributes {
                let filteredArray = section.filtered(using: NSPredicate { (evaluatedObject, bindings) -> Bool in
                    let atts = evaluatedObject as! UICollectionViewLayoutAttributes
                    return rect.intersects(atts.frame)
                }) as! [UICollectionViewLayoutAttributes]
                
                attributes.append(contentsOf: filteredArray)
            }
        }
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func sizeForItemWithColumnIndex(columnIndex: Int) -> CGSize {
        return CGSize(width: columnWidth, height: 30)
    }
    
    func calculateItemsSize() {
        itemsSize = [CGSize]()
        for index in 0..<numberOfColumns {
            itemsSize.append(sizeForItemWithColumnIndex(columnIndex: index))
        }
    }
}
