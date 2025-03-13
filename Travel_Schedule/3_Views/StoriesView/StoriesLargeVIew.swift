//
//  StoriesLargeVIew.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI

struct StoriesLargeVIew: View {
    
    let story: Story
    
    var body: some View {
        ZStack {
            Image(story.backgroundImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    ForEach(0..<Story.allStories.count) { _ in
                        ProgressBarView()
                    }
                }
                .padding(.horizontal, 12)
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(story.title)
                            .font(.system(size: 34))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Text(story.description)
                            .font(.system(size: 20))
                            .fontWeight(.regular)
                            .lineLimit(3)
                            .foregroundStyle(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    StoriesLargeVIew(story: Story.allStories[0])
}

