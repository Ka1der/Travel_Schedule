//
//  CarrierLogoView.swift
//  Travel_Schedule
//
//  Created by Kaider on 27.03.2025.
//

import SwiftUI

struct CarrierLogoView: View {
    let logoSource: CarrierModel.LogoSource
    var width: CGFloat = 38
    var height: CGFloat = 38
    
    var body: some View {
        Group {
            switch logoSource {
            case .local(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
            case .remote(let url):
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .foregroundColor(.orange)
                    @unknown default:
                        Image("rzdLogo2")
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 4)
        )
    }
}

struct CarrierLogoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CarrierLogoView(logoSource: .local(name: "rzdLogo2"))
                .previewLayout(.sizeThatFits)
                .padding()
            
            if let url = URL(string: "https://yastat.net/s3/rasp/media/data/company/logo/company_logo_26838.svg") {
                CarrierLogoView(logoSource: .remote(url: url))
                    .previewLayout(.sizeThatFits)
                    .padding()
            }
        }
    }
}
