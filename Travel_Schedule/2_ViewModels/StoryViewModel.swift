//
//  StoryViewModel.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI
import Combine

final class StoryViewModel: ObservableObject {
    @Published var currentStory: StoryModel
    @Published var currentStoryIndex: Int = 0
    @Published var progress: CGFloat = 0
    @Published var viewedStories: Set<Int> = []
    
    private let stories: [StoryModel]
    private let timerInterval: TimeInterval = 0.05
    private var timer: AnyCancellable?
    private let storyDuration: TimeInterval = 5
    
    init(stories: [StoryModel] = []) {
        self.stories = stories.isEmpty ? StoryMock.allStories : stories
        self.currentStory = self.stories[0]
    }
    
    func isStoryViewed(_ index: Int) -> Bool {
        return viewedStories.contains(index)
    }
    
    func startTimer() {
        progress = 0
        timer = Timer.publish(every: timerInterval, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.progress >= 1.0 {
                    self.nextStory()
                    self.progress = 0
                } else {
                    self.progress += CGFloat(self.timerInterval / self.storyDuration)
                }
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
        viewedStories.insert(currentStoryIndex)
        currentStoryIndex = (currentStoryIndex + 1) % stories.count
        currentStory = stories[currentStoryIndex]
    }
    
    func previousStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
        } else {
            currentStoryIndex = stories.count - 1
        }
        currentStory = stories[currentStoryIndex]
    }
}
