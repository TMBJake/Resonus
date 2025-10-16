//
//  PlaylistStore.swift
//  Resonus
//
//  Created by Jake on 2025-10-16.
//

import Foundation

@MainActor
final class PlaylistStore: ObservableObject {
    @Published private(set) var playlists: [Playlist] = []
    private let url: URL = {
        let d = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return d.appendingPathComponent("playlists.json")
    } ()
    
    init() { Task { await load()}}
    
    func load() async {
        if FileManager.default.fileExists(atPath: url.path),
           let data = try? Data(contentsOf: url),
           let list = try? JSONDecoder().decode([Playlist].self, from: data) {
            playlists = list
        }
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(playlists) {
            try? data.write(to: url, options: [.atomic])
        }
    }
    
    func create(name: String) {
        playlists.insert(Playlist(name: name), at: 0); save()
    }
    func rename(_ id: UUID, to name: String) {
        guard let i = playlists.firstIndex(where: { $0.id == id }) else { return }
        playlists[i].name = name; playlists[i].updatedAt = .init(); save()
    }
    func delete(_ ids: Set<UUID>) {
        playlists.removeAll { ids.contains($0.id) }; save()
    }
    func add(_ trackID: UUID, to pid: UUID) {
        guard let i = playlists.firstIndex(where: { $0.id == pid }) else { return }
        if !playlists[i].trackIDs.contains(trackID) {
            playlists[i].trackIDs.append(trackID); playlists[i].updatedAt = .init(); save()
        }
    }
    func remove(_ trackID: UUID, from pid: UUID) {
        guard let i = playlists.firstIndex(where: {$0.id == pid}) else { return }
        playlists[i].trackIDs.removeAll { $0 == trackID }; playlists[i].updatedAt = .init()
        save()
    }
    func moveTrack(pid: UUID, from: Int, to: Int) {
        guard let i = playlists.firstIndex(where: { $0.id == pid }) else { return }
        var arr = playlists[i].trackIDs
        let item = arr.remove(at: from); arr.insert(item, at: to);
        playlists[i].trackIDs = arr; playlists[i].updatedAt = .init(); save()
    }
}
