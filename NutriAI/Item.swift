//
//  Item.swift
//  NutriAI
//
//  Created by Наталья Атюкова on 31.10.2024.
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
