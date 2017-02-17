//
//  layoutTwo.swift
//  collectionViewDemo
//
//  Created by NEXTAcademy on 2/17/17.
//  Copyright © 2017 test. All rights reserved.
//

import UIKit

class layoutTwo: UICollectionViewLayout {

    
    let numberOfColumns = 20
    var itemAttributes = [[UICollectionViewLayoutAttributes]]()
    var itemsSize = [CGSize]()
    var contentSize : CGSize!
    
    override func prepare() {
        if self.collectionView?.numberOfSections == 0 {
            return
        }

        
        if self.itemAttributes.count > 0 {
            for section in 0..<self.collectionView!.numberOfSections {
                var numberOfItems : Int = self.collectionView!.numberOfItems(inSection: section)
                for index in 0..<numberOfItems {
                    
                    /*
                     x,x,x,x,x,x
                     x,0,0,0,0,0
                     x,0,0,0,0,0
                     
                     target x
                    */
                    if section != 0 && index != 0 {
                        continue
                    }
                    
                    var attributes : UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: IndexPath(item: index, section: section))!
                    if section == 0 {
                        var frame = attributes.frame
                        frame.origin.y = self.collectionView!.contentOffset.y
                        attributes.frame = frame
                    }
                    
                    if index == 0 {
                        var frame = attributes.frame
                        frame.origin.x = self.collectionView!.contentOffset.x
                        attributes.frame = frame
                    }
                }
            }
            return
        }
        
        if (itemsSize.count != numberOfColumns) {
            self.calculateItemsSize()
        }
        
        var column = 0
        var xOffset : CGFloat = 0
        var yOffset : CGFloat = 0
        var contentWidth : CGFloat = 0
        var contentHeight : CGFloat = 0
        
        for section in 0..<self.collectionView!.numberOfSections {
            var sectionAttributes = [UICollectionViewLayoutAttributes]()
            
            for index in 0..<numberOfColumns {
                var itemSize = itemsSize[index]
                var indexPath = IndexPath(item: index, section: section)
                var attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: itemSize.width, height: itemSize.height)
                
                if section == 0 && index == 0 {
                    attributes.zIndex = 1024;
                } else  if section == 0 || index == 0 {
                    attributes.zIndex = 1023
                }
                
                if section == 0 {
                    var frame = attributes.frame
                    frame.origin.y = self.collectionView!.contentOffset.y
                    attributes.frame = frame
                }
                if index == 0 {
                    var frame = attributes.frame
                    frame.origin.x = self.collectionView!.contentOffset.x
                    attributes.frame = frame
                }
                
                sectionAttributes.append(attributes)
                
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

            self.itemAttributes.append(sectionAttributes)
        }
        
        let attributes = (self.itemAttributes.last?.last)!
        contentHeight = attributes.frame.origin.y + attributes.frame.size.height
        self.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    override var collectionViewContentSize: CGSize {
        return self.contentSize
    }
    

    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.itemAttributes[indexPath.section][indexPath.row]
    }

    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if self.itemAttributes.count > 0 {
            for section in self.itemAttributes {
                let filteredArray = section.filter({ (attribute) -> Bool in
                    rect.intersects(attribute.frame)
                })
                attributes.append(contentsOf: filteredArray)
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    func sizeForItemWithColumnIndex(columnIndex: Int) -> CGSize {
        var text : String = ""
        switch (columnIndex) {
        case 0:
            text = "Col 0"
        case 1:
            text = "Col 1"
        case 2:
            text = "Col 2"
        case 3:
            text = "Col 3"
        case 4:
            text = "Col 4"
        case 5:
            text = "Col 5"
        case 6:
            text = "Col 6"
        default:
            text = "Col 7"
        }
        
        let size : CGSize = (text as NSString).size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 17.0)])
        let width : CGFloat = size.width + 25
        return CGSize(width: width, height: 30)
    }
    
    func calculateItemsSize() {

        for index in 0..<numberOfColumns {
            let size = sizeForItemWithColumnIndex(columnIndex: index)
            itemsSize.append(size)
        }
    }
}
