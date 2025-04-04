//
//  ImageLoader.swift
//  RickMorty25
//
//  Created by Borys Klykavka on 04.04.2025.
//

import UIKit

func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        completion(nil)
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(nil)
            return
        }

        guard let data = data, let image = UIImage(data: data) else {
            completion(nil)
            return
        }

        DispatchQueue.main.async {
            completion(image)
        }
    }
    .resume()
}
