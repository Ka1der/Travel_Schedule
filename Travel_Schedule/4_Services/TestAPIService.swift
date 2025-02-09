//
//  TestAPIService.swift
//  Travel_Schedule
//
//  Created by Kaider on 09.02.2025.
//

import Foundation
import OpenAPIURLSession

final class TestAPIService {
    
    func testNearestStations() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestStationsService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getNearestStations(
                        lat: 59.864177,
                        lng: 30.319163,
                        distance: 50
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testThread() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ThreadService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getThreadStations(
                        uid: "SU-1827A_c26_agent"
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testStationList() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = StationListService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getStationList(
                        apikey: Config.apiKey
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testSearch() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = SearchListService(
                client: client,
                apikey: Config.apiKey
            )
            
            let dateString = "2023-10-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else {
                print("Invalid date string")
                return
            }
            
            Task {
                do {
                    let stations = try await service.getScheduleBetweenStations(
                        apikey: Config.apiKey,
                        from: "s9600213",
                        to: "2000006",
                        transportTypes: "train",
                        date: date
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testShedule() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = ScheduleService(
                client: client,
                apikey: Config.apiKey
            )
            
            let dateString = "2023-10-01"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            guard let date = dateFormatter.date(from: dateString) else {
                print("Invalid date string")
                return
            }
            
            Task {
                do {
                    let stations = try await service.getScheduleOnStation(
                        apikey: Config.apiKey,
                        station: "s9600213",
                        transportTypes: "train",
                        date: date
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testNearestSettlement() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = NearestSettlementService(
                client: client,
                apikey: Config.apiKey
            )
            
            Task {
                do {
                    let stations = try await service.getNearestSettlement(
                        lat: 59.864177,
                        lng: 30.319163,
                        distance: 50
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testCarrier() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CarrierService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getCarrier(
                        apikey: Config.apiKey,
                        code: "rzd"
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
    func testCopyright() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            let service = CopyrightService(
                client: client,
                apikey: Config.apiKey
            )
            Task {
                do {
                    let stations = try await service.getCopyright(
                        apikey: Config.apiKey
                    )
                    print(stations)
                } catch {
                    print("Failed to fetch stations: \(error)")
                }
            }
        } catch {
            print("Failed to create client: \(error)")
        }
    }
    
}
