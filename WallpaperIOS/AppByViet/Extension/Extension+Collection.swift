//
//  Extension+Collection.swift
//  eWidget
//
//  Created by Three Bros on 09/12/2023.
//

import SwiftUI

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
