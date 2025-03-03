//
//  AvatarImage.swift
//  ForRent
//
//  Created by Eddie Nguyen on 2025-03-02.
//

import SwiftUI

struct AvatarImage: View {
    var avatarURL: String
    var size: Double
    
    var body: some View {
        AsyncImage(url: URL(string: avatarURL)) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(
                            Color(Constant.Color.primaryText),
                            lineWidth: 1
                        )
                }
        } placeholder: {
            PlaceholderImage(size: size)
        }
    }
}

#Preview {
    AvatarImage(avatarURL: "https://avatars.githubusercontent.com/u/84004761?v=4", size: 45)
}
