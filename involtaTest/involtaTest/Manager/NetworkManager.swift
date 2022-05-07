//
//  NetworkManager.swift
//  involtaTest
//
//  Created by Максим Клочков on 07.05.2022.
//

import UIKit


enum TableViewError: Error {
  case error(Error)
  case parseError
}

class NetworkManager {
    private var baseURL = "https://numero-logy-app.org.in/"
    private lazy var messagesURL = "getMessages?offset=\(offsetURL)"

    var offsetURL = 0
    var uploadedMessages: [String]?

    func fetchMessage(completionHandler: @escaping (Result<Messages, Error>) -> Void) {

        guard let url = URL(string: baseURL + messagesURL) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completionHandler(.failure(error))
            } else {
                do {
                    let currentMessages = try JSONDecoder().decode(Messages.self, from: data!)
                    completionHandler(.success(currentMessages))
                } catch {
                    completionHandler(.failure(error))
                }
            }
        }.resume()
    }

    func fetchMessageList(completionHandler: @escaping (Result<[String], Error>) -> Void) {
        fetchMessage(completionHandler: { result in
        completionHandler(result.map({ company in
            company.messageList
        }))
      })
    }
}

/*
 DispatchQueue.main.async {
 tableView.reloadData()
 }
 */
