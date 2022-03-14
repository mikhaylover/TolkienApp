import Foundation
import UIKit

fileprivate enum State {
    case loading
    case populated(BooksResponse)
    case empty
    case error

    var content: BooksResponse? {
        switch self {
        case let .populated(content):
            return content
        default:
            return nil
      }
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorView: UIView!

    private let networking = Networking()
    private var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBar()
        prepareTableView()
        loadBooks()
    }

    private func loadBooks() {
        state = .loading

        Networking().getBooksList(
            onSuccess: { [weak self] response in
                if response.books.isEmpty {
                    self?.state = .empty
                } else {
                    self?.state = .populated(response)
                }
            },
            onFailure: { [weak self] in
                self?.state = .error
            }
        )
    }

    private func setFooterView() {
        switch state {
        case .error:
          tableView.tableFooterView = errorView
        case .loading:
          tableView.tableFooterView = loadingView
        case .empty:
          tableView.tableFooterView = emptyView
        case .populated:
          tableView.tableFooterView = nil
        }
    }

    private func prepareNavigationBar() {
        title = "Tolkien books"
    }

    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let books = state.content?.books else {
            return
        }
        guard let chaptersVC = storyboard?.instantiateViewController(withIdentifier: String(describing: ChaptersViewController.self)) as? ChaptersViewController else {
            return
        }
        chaptersVC.book = books[indexPath.row]
        navigationController?.pushViewController(chaptersVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.content?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let books = state.content?.books {
            cell.textLabel?.text = books[indexPath.row].name
        }
        return cell
    }
}
