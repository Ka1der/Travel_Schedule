//
//  StoryMock.swift
//  Travel_Schedule
//
//  Created by Kaider on 20.03.2025.
//

import Foundation

struct StoryMock {
    
    static let allStories: [StoryModel] = [
        StoryModel(backgroundImage: "Stories1",
              title: "🎉🎉🎉",
              description: "Text1 Text1 Text1"),
        
        StoryModel(backgroundImage: "Stories2",
              title: "😍😍😍",
              description: "Text2 Text2 Text2"),
        
        StoryModel(backgroundImage: "Stories3",
              title: "🥬🥬🥬",
              description: "Text3 Text3 Text3"),
        
        StoryModel(backgroundImage: "Stories4",
              title: "🥑🥑🥑",
              description: "Text4 Text4 Text4"),
        
        StoryModel(backgroundImage: "Stories5",
              title: "🧀🧀🧀",
              description: "Text5 Text5 Text5")
    ]
}

let stories = StoryMock.allStories
