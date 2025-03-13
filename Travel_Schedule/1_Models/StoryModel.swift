//
//  StoryModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI

struct Story {
    let backgroundImage: String
    let title: String
    let description: String
    
    static let allStories: [Story] = [
        Story(backgroundImage: "Stories1",
                    title: "🎉🎉🎉",
                    description: "Text1 Text1 Text1"),
        
        Story(backgroundImage: "Stories2",
                    title: "😍😍😍",
                    description: "Text2 Text2 Text2"),
        
        Story(backgroundImage: "Stories3",
                    title: "🥬🥬🥬",
                    description: "Text3 Text3 Text3"),
        
        Story(backgroundImage: "Stories4",
                    title: "🥑🥑🥑",
                    description: "Text4 Text4 Text4"),
        
        Story(backgroundImage: "Stories5",
                    title: "🧀🧀🧀",
                    description: "Text5 Text5 Text5")
    ]
}


