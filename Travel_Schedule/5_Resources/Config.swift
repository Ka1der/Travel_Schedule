//
//  Config.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation

struct Config {
    static let apiKey = "7743d05f-1104-4d10-b184-60af97459931"
    
    struct Coordinates {
           struct City {
               let name: String
               let lat: Double
               let lng: Double
           }
           
           static let moscow = City(
               name: "Москва",
               lat: 55.7522,
               lng: 37.6156
           )
           
           static let saintPetersburg = City(
               name: "Санкт-Петербург",
               lat: 59.9386,
               lng: 30.3141
           )
           
           static let kazan = City(
               name: "Казань",
               lat: 55.7887,
               lng: 49.1221
           )
           
           static let cities: [City] = [
               moscow,
               saintPetersburg,
               kazan
           ]
           
           static let defaultSearchRadius = 50
       }
   }
