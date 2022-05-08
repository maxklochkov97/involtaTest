//
//  NetworkManager.swift
//  involtaTest
//
//  Created by Максим Клочков on 07.05.2022.
//

import UIKit

class NetworkManager {
    private var baseURL = "https://numero-logy-app.org.in/"
    private lazy var messagesURL = "getMessages?offset=0"
    var isPagination = false

    weak var messagesCountDelegate: ModelMessagesCountDelegate?

    var uploadedMessages: [String]?

    func fetchMessage(pagination: Bool = false, completionHandler: @escaping (Result<Messages, Error>) -> Void) {

        if pagination {
            if let offset = self.messagesCountDelegate?.modelMessages.count {
                self.messagesURL = "getMessages?offset=\(offset)"
            }
            isPagination = true
        }

        DispatchQueue.global().asyncAfter(deadline: .now() + (pagination ? 3 : 1), execute: {
            guard let url = URL(string: self.baseURL + self.messagesURL) else { return }

            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    do {
                        let currentMessages = try JSONDecoder().decode(Messages.self, from: data!)
                        let newValue = try JSONDecoder().decode(Messages.self, from: data!)
                        completionHandler(.success(pagination ? newValue : currentMessages))

                        if pagination {
                            self.isPagination = false
                        }

                    } catch {
                        print("Что-то не так в \(#function)")
                        completionHandler(.failure(error))
                    }
                }
            }.resume()
        })
    }

    func fetchMessageList(pagination: Bool = false, completionHandler: @escaping (Result<[String], Error>) -> Void) {
        fetchMessage(pagination: pagination, completionHandler: { result in
            completionHandler(result.map({ company in
                company.messageList.reversed()
            }))
        })
    }
}
