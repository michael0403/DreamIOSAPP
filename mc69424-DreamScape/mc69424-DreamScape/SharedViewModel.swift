//
//  SharedViewModel.swift
//  mc69424-DreamScape
//
//  Created by Michael Cheng on 12/3/23.
//
import SwiftUI

class SharedViewModel: ObservableObject {
    @Published var selectedEmoji: String? = nil
    let emojiChoices = ["👶", "🐶", "🏃", "📚", "☠️", "🍔"]

    let emojiToModelMap: [String: String] = [
        "📚": "Textbooks",
        "🏃": "running",
        "☠️": "death",
        "👶": "Baby_Yoda",
        "🍔": "pancakes",
        "🐶": "dog"
    ]

    var selectedModelName: String? {
        selectedEmoji.flatMap { emojiToModelMap[$0] }
    }
}
    

