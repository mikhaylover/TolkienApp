import Alamofire
import Foundation

class Networking {
    private let booksURL = URL(string: "https://the-one-api.dev/v2/book")!

    private func bookChaptersUrl(_ id: String) -> URL {
        var url = booksURL
        url.appendPathComponent(id)
        url.appendPathComponent("chapter")
        return url
    }

    func getBooksList(
        onSuccess: @escaping (BooksResponse) -> Void,
        onFailure: @escaping () -> Void
    ) {
        AF.request(booksURL).responseDecodable(of: BooksResponse.self) { response in
            switch response.result {
            case let .success(books):
                onSuccess(books)
            case let .failure(error):
                print("ERROR: \(error)")
                onFailure()
            }
        }
    }

    func getBookChapters(
        id: String,
        onSuccess: @escaping (ChaptersResponse) -> Void,
        onFailure: @escaping () -> Void
    ) {
        AF.request(bookChaptersUrl(id)).responseDecodable(of: ChaptersResponse.self) { response in
            switch response.result {
            case let .success(chapters):
                onSuccess(chapters)
            case let .failure(error):
                print("ERROR: \(error)")
                onFailure()
            }
        }
    }
}
