//
//  UIImage+Resized.swift
//  TrendingRepos
//
//  Created by Ahd on 9/8/24.
//

import SwiftUI

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let scale = width / self.size.width
        let height = self.size.height * scale
        let size = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
