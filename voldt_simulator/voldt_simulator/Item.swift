//
//  Item.swift
//  voldt_simulator
//
//  Created by Emilie Weiss on 04/05/2025.
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
