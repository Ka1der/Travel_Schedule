//
//  StoriesView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct StoriesView: View {
    var body: some View {
        GeometryReader { geomery in
            ZStack{
                Image("StoriesTestPicture")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 92, height: 140)
                    .cornerRadius(16)
                    .clipped()
                VStack {
                    Spacer()
                    Text("Test Text")
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)
                }
                .frame(width: 92, height: 140)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 4)
                    .frame(width: 92, height: 140)
            }
        }
        .frame(width: 92, height: 140)
    }
}

#Preview {
    StoriesView()
}
