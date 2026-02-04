//
//  SingleBookView.swift
//  GutenBooks
//
//  Created by Viktor Zavhorodnii on 03/02/2026.
//

import SwiftUI
import Kingfisher

struct SingleBookView: View {
    @Binding var book: Book
    
    let isShownFromFavorites: Bool
    
    var body: some View {
        HStack {
            KFImage(book.coverURL)
                .placeholder {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "book.closed")
                                .foregroundStyle(.secondary)
                        )
                }
                .cancelOnDisappear(true)
                .resizable()
                .frame(width: 64, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(formatList(book.authors))
                    .font(.default)
                    .foregroundStyle(.secondary)
                if isShownFromFavorites {
                    HStack(spacing: 8) {
                        Text(formatList(book.languages))
                        Text("•")
                        Text("\(book.downloadCount.formatted(.number)) downloads")
                    }
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: { book.isFavorite.toggle() }) {
                Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                    .foregroundStyle(book.isFavorite ? Color.accentColor : .secondary)
            }
            .imageScale(.large)
            .buttonStyle(.plain)
        }
    }
    
    private func formatList(_ items: [String]) -> String{
        guard !items.isEmpty else { return "—" }
        let limit = 2
        if items.count <= limit {
            return items.joined(separator: ", ")
        } else {
            let head = items.prefix(limit).joined(separator: "; ")
            let more = items.count - limit
            return "\(head) and \(more) more"
        }
    }
}

#Preview("Regular", traits: .sizeThatFitsLayout) {
    @Previewable @State var book: Book = Book.sampleData[0]
    SingleBookView(book: $book, isShownFromFavorites: false)
}

#Preview("Favorites", traits: .sizeThatFitsLayout) {
    @Previewable @State var favBook: Book = Book.sampleData[0]
    SingleBookView(book: $favBook, isShownFromFavorites: true)
}
