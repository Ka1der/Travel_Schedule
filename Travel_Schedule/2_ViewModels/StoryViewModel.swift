//
//  StoryViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI
import Combine

class StoryViewModel: ObservableObject {
    @Published var currentStory: Story
    @Published var currentStoryIndex: Int = 0
    
    private let stories: [Story]
    private let timerInterval: TimeInterval = 5
    private var timer: AnyCancellable?
    
    init(stories: [Story] = Story.allStories) {
        self.stories = stories
        self.currentStory = stories[0]
    }
    
    func startTimer() {
        timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                self.nextStory()
            }
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func restartTimer() {
        stopTimer()
        startTimer()
    }
    
    func nextStory() {
        currentStoryIndex = (currentStoryIndex + 1) % stories.count
        currentStory = stories[currentStoryIndex]
    }
}

