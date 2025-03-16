//
//  StoriesLargeView.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//


import SwiftUI
import NavigationKit

struct StoriesLargeView: View {
    
    let story: Story
    @EnvironmentObject var navigationManager: NavigationManager
    @StateObject private var viewModel = StoryViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(viewModel.currentStory.backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .cornerRadius(40)
                
                VStack{
                    HStack{
                        ForEach(0..<Story.allStories.count, id: \.self) { index in
                            ProgressBarView(
                                index: index,
                                currentIndex: viewModel.currentStoryIndex,
                                progress: viewModel.progress
                            )
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 28)
                    
                    HStack{
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
                    
                    Spacer()
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .onTapGesture {
            viewModel.nextStory()
            viewModel.restartTimer()
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    StoriesLargeView(story: Story.allStories[0])
        .environmentObject(NavigationKit.createNavigationManager())
}
