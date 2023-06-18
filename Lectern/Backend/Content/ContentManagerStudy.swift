//
//  ContentManagerStudy.swift
//  Lectern
//
//  Created by Nathan Choi on 6/17/23.
//

import SwiftUI

struct GPTResponse: Codable {
    let role: String
    let content: String
}

extension ContentManager {

    func blurt() {
        let url = URL(string: URL_K.blurt)!
        let req = URLRequest(url: url)

        Task {
            let _, data = try? await URLSession().data(for: req)

            guard let json = JSONDecoder().decode(GPTResponse.self, from: data) else { return }

            logger.info(json)
        }
    }
}
