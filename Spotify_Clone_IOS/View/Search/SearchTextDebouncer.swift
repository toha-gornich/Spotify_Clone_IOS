//
//  SearchTextDebouncer.swift
//  Spotify_Clone_IOS
//
//  Created by Горніч Антон on 16.02.2026.
//


import SwiftUI
import Combine

class SearchTextDebouncer: ObservableObject {
    @Published var searchText: String = ""
    @Published var debouncedSearchText: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .assign(to: &$debouncedSearchText)
    }
}