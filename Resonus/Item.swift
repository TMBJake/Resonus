//
//  Item.swift
//  Resonus
//
//  Created by macuser on 2025-10-16.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
