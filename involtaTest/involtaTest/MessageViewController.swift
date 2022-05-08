//
//  ViewController.swift
//  involtaTest
//
//  Created by Максим Клочков on 06.05.2022.
//

import UIKit

class MessageViewController: UIViewController {
    
    var modelMessages = [String]()
    private var networkManager = NetworkManager()
    private var tableViewError: Error?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: MessageTableViewCell.identifier)
        tableView.register(ErrorTableViewCell.self, forCellReuseIdentifier: ErrorTableViewCell.identifier)
        return tableView
    }()
    
    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return control
    }()
    
    @objc func refresh(sender: UIRefreshControl) {
        guard !networkManager.isPagination else { return }

        self.networkManager.fetchMessageList(pagination: true) { [weak self] result in

            guard let oldMessageCount = self?.modelMessages.count else { return }

            switch result {
            case .success(let moreData):
                self?.modelMessages.insert(contentsOf: moreData, at: 0)
                self?.tableViewError = nil
            case.failure(let error):
                self?.tableViewError = TableViewError.error(error)
                print("Что-то не так в \(#function)")
            }
            
            DispatchQueue.main.async {
                guard let newMessageCount = self?.modelMessages.count else { return }
                let row = newMessageCount - oldMessageCount
                let indexPath = IndexPath(row: row, section: 0)

                self?.tableView.reloadData()
                self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                sender.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        layout()
        loadMessageFromServer(isFirstRequest: true)
    }
    
    private func setupView() {
        networkManager.vcDelegate = self
        tableView.refreshControl = refreshControl
        view.backgroundColor = .systemBackground
    }
    
    func loadMessageFromServer(isFirstRequest: Bool) {
        networkManager.fetchMessageList(completionHandler: { [weak self] answer in
            switch answer {
            case .success(let messages):
                self?.modelMessages.insert(contentsOf: messages, at: 0)
                self?.tableViewError = nil
            case.failure(let error):
                self?.tableViewError = TableViewError.error(error)
                print("Что-то не так в \(#function)")
            }
            
            DispatchQueue.main.async {
                if isFirstRequest {
                    guard let messageCount = self?.modelMessages.count else { return }
                    let indexPath = IndexPath(row: messageCount == 0 ? 0 : messageCount - 1, section: 0)
                    self?.tableView.reloadData()
                    self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                } else {
                    let indexPath = IndexPath(row: 0, section: 0)
                    print("Сработал повторный запрос")
                    self?.tableView.reloadData()
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                }
            }
        })
    }
    
    private func layout() {
        [tableView].forEach({ view.addSubview($0)})
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}


// MARK: - UITableViewDataSource
extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewError != nil {
            return 1
        } else {
            return modelMessages.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableViewError == nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            }
            
            cell.setupCell(modelMessages[indexPath.row])
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.identifier, for: indexPath) as? ErrorTableViewCell else {
                return UITableViewCell()
            }
            cell.tapTryAgainDelegate = self
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension MessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - TapTryAgainDelegate
extension MessageViewController: TapTryAgainDelegate {}

// MARK: - ModelMessagesCountDelegate
extension MessageViewController: ModelMessagesCountDelegate {}
