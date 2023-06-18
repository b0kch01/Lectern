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
            do {
                let (data, _) = try await URLSession.shared.data(for: req)
                let json = try JSONDecoder().decode(GPTResponse.self, from: data)
                
                print(json)
            } catch {
                logger.error("\(error)")
            }
        }
    }
}
