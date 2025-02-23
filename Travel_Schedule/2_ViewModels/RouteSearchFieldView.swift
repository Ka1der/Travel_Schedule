//
//  RouteSearchFieldView.swift
//  Travel_Schedule
//
//  Created by Kaider on 23.02.2025.
//

import SwiftUI

struct RouteSearchFieldView: View {
    
    @State private var fromText: String = ""
    @State private var toText: String = ""
    
    var body: some View {
        HStack{
            ZStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.blue)
                    .frame(width: 343, height: 128)
                
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.white)
                    .frame(width: 259, height: 96)
                    .padding(.leading, 16)
                
                HStack {
                    VStack(spacing: 0) {
                        TextField("Откуда", text: $fromText)
                            .textFieldStyle(.plain)
                            .padding(.leading, 16)
                            .frame(width: 259, height: 48)
                            .font(.system(size: 17))
                            .padding(.top, 14)
                        
                        TextField("Куда", text: $toText)
                            .textFieldStyle(.plain)
                            .padding(.leading, 16)
                            .frame(width: 259, height: 48)
                            .font(.system(size: 17))
                            .padding(.bottom, 14)
                    }
                    .frame(width: 259, height: 96)
                    .padding(.leading, 16)
                }
                
                ZStack {
                    Circle()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.white)
                    Image("ChangeArrows")
                }
                .padding(.leading, 291)
            }
        }
    }
}

//#Preview {
//    RouteSearchFieldView()
//}
