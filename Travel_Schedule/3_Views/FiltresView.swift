//
//  FiltresView.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.03.2025.
//

import SwiftUI

struct FiltersView: View {
    @State private var selectedTimes: Set<String> = []
    @State private var showTransfers: Bool? = nil
    @Environment(\.presentationMode) var presentationMode
    
    private let timePeriods = [
        "Утро 06:00 - 12:00",
        "День 12:00 - 18:00",
        "Вечер 18:00 - 00:00",
        "Ночь 00:00 - 06:00"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 30) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 16)
                
                ForEach(timePeriods, id: \.self) { period in
                    HStack {
                        Text(period)
                            .font(.system(size: 17))
                        Spacer()
                        CheckBox(isChecked: selectedTimes.contains(period)) {
                            if selectedTimes.contains(period) {
                                selectedTimes.remove(period)
                            } else {
                                selectedTimes.insert(period)
                            }
                        }
                    }
                }
                
                Text("Показывать варианты с\nпересадками")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 16)
                    .lineLimit(2)
                
                VStack(spacing: 30){
                    RadioButton(text: "Да", isSelected: showTransfers == true) {
                        showTransfers = true
                    }
                    RadioButton(text: "Нет", isSelected: showTransfers == false) {
                        showTransfers = false
                    }
                }
                .padding(.top, 16)
            }
            
            Spacer()
            
            VStack {
                if !selectedTimes.isEmpty && showTransfers != nil {
                    Button(action: {
                        // TO-DO: переход на отфильтрованный экран
                    }) {
                        Text("Применить")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color.blue)
                            .cornerRadius(16)
                    }
                } else {
                    Color.clear
                        .frame(height: 60)
                }
            }
            .padding(.bottom, 24)
        }
        .padding(24)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.system(size: 17))
            }
        )
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheckBox: View {
    var isChecked: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if isChecked {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RadioButton: View {
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 17))
            Spacer()
            Button(action: action) {
                ZStack {
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FiltersView()
        }
    }
}
