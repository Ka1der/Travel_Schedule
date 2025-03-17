//
//  StoriesSmallViewedView.swift
//  Travel_Schedule
//
//  Created by Kaider on 17.03.2025.
//

import SwiftUI

struct StoriesSmallViewedView: View {
    let story: Story
    let isViewed: Bool
    
    var body: some View {
        
        ZStack{
            Image(story.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 92, height: 140)
                .cornerRadius(16)
                .clipped()
                .saturation(isViewed ? 0.5 : 1)
            VStack {
                Spacer()
                Text(story.title)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundStyle(.white)
                    .padding(.bottom, 8)
            }
            .frame(width: 92, height: 140)
        }
        .opacity(0.5)
        .frame(width: 92, height: 140)
    }
}

#Preview {
    StoriesSmallViewedView(story: Story.allStories[0], isViewed: false)
}
