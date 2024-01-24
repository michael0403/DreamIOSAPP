//
// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
//

import SwiftUI

struct EmojiExplanationView: View {
    let emojiChoices: [String: String] = [
        "👶": "Baby -  represent new beginnings, growth, potential, or innocence, as well as your own childlike qualities",
        "🐶": "Animal - Connected to nature and survival, or they can represent literal influences from waking life like pets",
        "🏃": "Running - reflects a sense of threat, fear, or avoidance",
        "📚": "Books -  preparedness, competence, or self-evaluation",
        "☠️": "Death - represent endings, transformation, or renewal, as well as fears of loss, change, or the unknown",
        "🍔": "Food - pleasure, indulgence, guilt, or excess"
    ]

    var body: some View {
            NavigationView {
                List(emojiChoices.keys.sorted(), id: \.self) { emoji in
                    HStack {
                        Text(emoji)
                            .font(.custom("Cotane Beach", size: 30))
                        Text(emojiChoices[emoji] ?? "")
                            .font(.custom("Cotane Beach", size: 16))
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Emoji Meanings")
                            .font(.custom("Cotane Beach", size: 35))
                    }
                }
            }
        }
    }

