//
//  CircularPlaceholderImage.swift
//  TrendingRepos
//
//  Created by Ahd on 9/7/24.
//

import SwiftUI

struct CircularPlaceholderImage: View {
    let diameter: CGFloat
    
    var body: some View {
        
        Circle()
            .fill(Color.gray.opacity(0.2))
            .frame(width: diameter, height: diameter)
    }
}

#Preview {
    CircularPlaceholderImage(diameter: 100)
}
