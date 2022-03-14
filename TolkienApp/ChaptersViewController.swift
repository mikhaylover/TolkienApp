import Foundation
import UIKit

class ChaptersViewController: UIViewController {
    enum State {
        case loading
        case populated(ChaptersResponse)
        case empty
        case error

        var content: ChaptersResponse? {
            switch self {
            case let .populated(content):
                return content
            default:
                return nil
          }
        }
    }

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var errorView: UIView!

    var book: Book!
    var state = State.loading {
        didSet {
            setFooterView()
            tableView.reloadData()
        }
    }

    private let networking = Networking()

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareNavigationBar()
        prepareTableView()
        loadChapters()
    }

    private func loadChapters() {
        state = .loading

        Networking().getBookChapters(
            id: book.id,
            onSuccess: { [weak self] response in
                if response.chapters.isEmpty {
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
        title = book.name
    }

    private func prepareTableView() {
        tableView.dataSource = self
    }

}

extension ChaptersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.content?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let chapters = state.content?.chapters {
            cell.textLabel?.text = chapters[indexPath.row].name
        }
        return cell
    }
}
