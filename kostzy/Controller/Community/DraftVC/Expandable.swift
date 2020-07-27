//
//  Expandable.swift
//  kostzy
//
//  Created by Rayhan Martiza Faluda on 24/07/20.
//  Copyright © 2020 Apple Developer Academy. All rights reserved.
//

import UIKit

protocol Expandable {
    func collapse()
    func expand(in collectionView: UICollectionView)
}
