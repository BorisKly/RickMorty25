//
//  ImageLoader.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit

func loadImage(from urlString: String, completion: @escaping (UIImage) -> Void) {
    let defaultImage = UIImage(named: "photo") ?? UIImage()
    guard let url = URL(string: urlString) else {
        completion(defaultImage)
        return
    }
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            DispatchQueue.main.async {
                completion(defaultImage)
            }
            return
        }

        guard let data = data, let image = UIImage(data: data) else {
            DispatchQueue.main.async {
                completion(defaultImage)
            }
            return
        }

        DispatchQueue.main.async {
            completion(image)
        }
    }
    .resume()
}
