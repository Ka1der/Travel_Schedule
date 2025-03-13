//
//  ProgressBarView.swift
//  Travel_Schedule
//
//  Created by Kaider on 13.03.2025.
//

import SwiftUI

struct ProgressBarView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 6)
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: 6)
            .foregroundStyle(.white)
    }
}

#Preview {
    ProgressBarView()
}
