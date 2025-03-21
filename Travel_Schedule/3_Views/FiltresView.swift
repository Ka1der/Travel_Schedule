//
//  FiltresView.swift
//  Travel_Schedule
//
//  Created by Kaider on 04.03.2025.
//

import SwiftUI
import NavigationKit

struct FiltersView: View {
    @StateObject private var viewModel = FiltersViewModel()
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            VStack(alignment: .leading, spacing: 30) {
                Text("Время отправления")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 16)
                
                ForEach(viewModel.timePeriods, id: \.self) { period in
                    HStack {
                        Text(period)
                            .font(.system(size: 17))
                        Spacer()
                        CheckBox(isChecked: viewModel.selectedTimes.contains(period)) {
                            viewModel.toggleTimeSelection(for: period)
                        }
                    }
                }
                
                Text("Показывать варианты с\nпересадками")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 16)
                    .lineLimit(2)
                
                VStack(spacing: 30){
                    RadioButton(text: "Да", isSelected: viewModel.showTransfers == true) {
                        viewModel.setShowTransfers(value: true)
                    }
                    
                    RadioButton(text: "Нет", isSelected: viewModel.showTransfers == false) {
                        viewModel.setShowTransfers(value: false)
                    }
                }
                .padding(.top, 16)
            }
            
            Spacer()
            
            VStack {
                if viewModel.canApplyFilters {
                    Button(action: {
                        viewModel.applyFilters()
                        presentationMode.wrappedValue.dismiss()
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
                    .foregroundColor(isDarkModeEnabled ? .white : .black)
                    .font(.system(size: 17))
            }
        )
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

struct CheckBox: View {
    var isChecked: Bool
    var action: () -> Void
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(isDarkModeEnabled ? .white : .black, lineWidth: 2)
                    .frame(width: 24, height: 24)
                
                if isChecked {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(isDarkModeEnabled ? .white : .black)
                        .frame(width: 24, height: 24)
                        .overlay(
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(isDarkModeEnabled ? .black : .white)
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
    @AppStorage("isDarkMode") private var isDarkModeEnabled: Bool = false
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 17))
            Spacer()
            Button(action: action) {
                ZStack {
                    Circle()
                        .stroke(isDarkModeEnabled ? .white : .black, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(isDarkModeEnabled ? .white : .black)
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
