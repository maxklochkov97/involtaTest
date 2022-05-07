//
//  Model.swift
//  involtaTest
//
//  Created by Максим Клочков on 06.05.2022.
//

import Foundation

struct Messages: Decodable {
    var messageList: [String]

    private enum CodingKeys: String, CodingKey {
        case messageList = "result"
    }
}
