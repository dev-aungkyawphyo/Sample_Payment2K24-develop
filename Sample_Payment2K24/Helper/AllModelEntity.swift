//
//  AllModelEntity.swift
//  Sample_Payment2K24
//
//  Created by Aung Kyaw Phyo on 28/07/2024.
//

import Foundation
import UIKit

struct ProductPoster {
    var poster: UIImage
}

struct RecentNumber {
    var icon: UIImage
    var description: String
}

struct Transfer {
    var recent: RecentNumber
    var title: String
}

struct HistoryRecent {
    var transfer: Transfer
    var amount: Double
}
