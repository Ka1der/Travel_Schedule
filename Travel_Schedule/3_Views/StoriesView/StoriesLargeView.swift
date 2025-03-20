//
//  StoriesLargeView.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI
import NavigationKit

// MARK: - StoriesLargeView

struct StoriesLargeView: View {
    
    // MARK: - Properties
    
    let story: StoryModel
    let initialIndex: Int
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var viewModel: StoryViewModel
    
    // MARK: - Content
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundImageView(geometry)
                VStack {
                    progressBar
                    closeButton
                    Spacer()
                    storyContent
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            viewModel.currentStoryIndex = initialIndex
            viewModel.currentStory = stories[initialIndex]
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .onTapGesture(perform: handleTap)
        .gesture(dragGesture)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Views
    
    private func backgroundImageView(_ geometry: GeometryProxy) -> some View {
        Image(viewModel.currentStory.backgroundImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .cornerRadius(40)
    }
    
    private var progressBar: some View {
        HStack {
            ForEach(0..<stories.count, id: \.self) { index in
                ProgressBarView(
                    index: index,
                    currentIndex: viewModel.currentStoryIndex,
                    progress: viewModel.progress
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 28)
    }
    
    private var closeButton: some View {
        HStack {
            Spacer()
            Button("", systemImage: "xmark.circle.fill") {
                navigationManager.navigateBack()
            }
            .symbolRenderingMode(.palette)
            .foregroundStyle(.white, .black)
            .font(.system(size: 30))
            .padding(.trailing, 12)
            .padding(.top, 4)
        }
    }
    
    private var storyContent: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.currentStory.title)
                    .font(.system(size: 34))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text(viewModel.currentStory.description)
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
    
    private func handleTap(location: CGPoint) {
        let width = UIScreen.main.bounds.width
        if location.x < width / 2 {
            viewModel.previousStory()
        } else {
            viewModel.nextStory()
        }
        viewModel.restartTimer()
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                if value.translation.width > 50 {
                    viewModel.previousStory()
                } else if value.translation.width < -50 {
                    viewModel.nextStory()
                }
                viewModel.restartTimer()
            }
    }
}

#Preview {
    StoriesLargeView(story: stories[0], initialIndex: 0)
        .environmentObject(NavigationKit.createNavigationManager())
        .environmentObject(StoryViewModel())
}
