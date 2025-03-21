//
//  StoriesSmallView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct StoriesSmallView: View {
    let story: StoryModel
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
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 92, height: 140)
            }
        
        .frame(width: 92, height: 140)
    }
}

#Preview {
    StoriesSmallView(story: stories[0], isViewed: false)
}
