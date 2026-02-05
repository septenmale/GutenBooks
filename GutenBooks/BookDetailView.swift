import SwiftUI
import Kingfisher

struct BookDetailView: View {
    @Bindable var book: Book
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                KFImage(book.coverURL)
                    .placeholder {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "book.closed")
                                    .foregroundStyle(.secondary)
                            )
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .frame(width: 192, height: 288)
                VStack(spacing: 8) {
                    Text(book.title)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                    Text(book.authors.joined(separator: "; "))
                        .font(.title3.bold())
                        .foregroundStyle(.secondary)
                    
                }
                FavoriteButton(isFavorite: $book.isFavorite)
                HStack(spacing: 16) {
                    StatCard(icon: "arrow.down.circle", title: "DOWNLOADS", values: [book.downloadCount.formatted(.number)])
                    StatCard(icon: "globe", title: "LANGUAGE", values: book.languages)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary")
                        .font(.title2.bold())
                    Group {
                        if let summary = book.summary, !summary.isEmpty {
                            Text(summary)
                        } else {
                            Text("No summary available.")
                        }
                    }
                    .font(.default)
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                TagsSection(icon: "tag", title: "Subjects", tags: book.bookshelves)
            }
            .padding()
        }
    }
}

private struct FavoriteButton: View {
    @Binding var isFavorite: Bool
    
    private var foregroundColor: Color { isFavorite ? .primary : .white }
    private var backgroundColor: Color { isFavorite ? Color(.tertiarySystemFill) : .accentColor }
    private var title: String { isFavorite ? "Remove from Favorites" : "Add to Favorites" }
    private var icon: String { isFavorite ? "heart.fill" : "heart" }
    
    var body: some View {
        Button(action: { isFavorite.toggle() }) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .fontWeight(.semibold)
            .foregroundStyle(foregroundColor)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct StatCard: View {
    let icon: String
    let title: String
    let values: [String]
    
    var body: some View {
        VStack(spacing: 8) {
            Group {
                Image(systemName: icon)
                Text(title)
            }
            .font(.default)
            .foregroundStyle(.secondary)
            
            HStack {
                ForEach(values, id: \.self) { value in
                    Text(value.uppercased())
                        .font(.default.bold())
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.tertiarySystemFill))
        )
    }
}

private struct TagsSection: View {
    let icon: String
    let title: String
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.title2.bold())
            }
            
            Group {
                if tags.isEmpty {
                    Text("—")
                } else {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(tags, id: \.self) { tag in
                                Text(tag)
                                    .lineLimit(1)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule().fill(Color(.tertiarySystemFill))
                                    )
                            }
                        }
                    }
                }
            }
            .font(.default)
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    @Previewable @State var book: Book = Book.sampleData[0]
    NavigationStack {
        BookDetailView(book: book)
    }
}
