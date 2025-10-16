//
//  Playlist.swift
//  Resonus
//
//  Created by Jake on 2025-10-16.
//

import Foundation

struct Playlist: Identifiable, Codable, Equatable {
    var id: UUID = .init()
    var name: String
    var trackIDs: [UUID] = []
    var createdAt: Date = .init()
    var updatedAt: Date = .init()
    
}

