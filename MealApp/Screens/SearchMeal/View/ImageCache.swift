//
//  ImageCache.swift
//  MealApp
//
//  Created by Kshitija Shaktawat on 5/29/23.
//

import SwiftUI

/**
  Image Cache

  A singleton class for caching and loading images from URLs.

  ## Usage

  To use the 'ImageCache', access the shared instance by calling 'ImageCache.shared'.
 */
class ImageCache {
    
    static let shared = ImageCache()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func loadImage(from url: URL?, completion: @escaping (UIImage?) -> Void) {
        if let url = url {
            if let cachedImage = cache.object(forKey: url as NSURL) {
                completion(cachedImage)
            } else {
                URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
                    guard let data = data, let image = UIImage(data: data) else {
                        completion(nil)
                        return
                    }
                    
                    self?.cache.setObject(image, forKey: url as NSURL)
                    completion(image)
                }.resume()
            }
        }
    }
}
