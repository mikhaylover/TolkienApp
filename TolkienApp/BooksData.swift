struct Book: Decodable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
    }
}

struct Chapter: Decodable {
    let id: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name = "chapterName"
    }
}

struct BooksResponse: Decodable {
    let books: [Book]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case books = "docs"
        case count = "total"
    }
}

struct ChaptersResponse: Decodable {
    let chapters: [Chapter]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case chapters = "docs"
        case count = "total"
    }
}
