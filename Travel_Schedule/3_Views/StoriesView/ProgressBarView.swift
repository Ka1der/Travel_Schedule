//
//  ProgressBarView.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI

struct ProgressBarView: View {
    let index: Int
    let currentIndex: Int
    let progress: CGFloat
    
    init(index: Int = 0, currentIndex: Int = 0, progress: CGFloat = 0) {
        self.index = index
        self.currentIndex = currentIndex
        self.progress = progress
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 3)
                .foregroundStyle(.white)
            
            RoundedRectangle(cornerRadius: 6)
                .fixedSize(horizontal: false, vertical: true)
                .frame(height: 3)
                .foregroundStyle(.blue)
                .scaleEffect(x: getCurrentProgress(), y: 1, anchor: .leading)
        }
    }
    private func getCurrentProgress() -> CGFloat {
        if index < currentIndex {
            return 1
        } else if index == currentIndex {
            return progress
        }
        return 0
    }
}


#Preview {
    ProgressBarView(index: 0, currentIndex: 0, progress: 0.5)
}
