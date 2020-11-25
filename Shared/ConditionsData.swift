//
//  ConditionsData.swift
//  conditions-swiftui
//
//  Created by Noah Scholfield on 9/5/20.
//

import Foundation

struct SunData: Codable {
    var sunrise: Date
    var sunset: Date
    var solar_noon: Date
    var day_length: Int
    var civil_twilight_begin: Date
    var civil_twilight_end: Date
    var nautical_twilight_begin: Date
    var nautical_twilight_end: Date
    var astronomical_twilight_begin: Date
    var astronomical_twilight_end: Date
    
    init() {
        sunrise = Date()
        sunset = Date()
        solar_noon = Date()
        day_length = -1
        civil_twilight_begin = Date()
        civil_twilight_end = Date()
        nautical_twilight_begin = Date()
        nautical_twilight_end = Date()
        astronomical_twilight_begin = Date()
        astronomical_twilight_end = Date()
    }
}

struct SunDataWrapper: Codable {
    var results: SunData
    var status: String
    
    init() {
        results = SunData()
        status = "Placeholder"
    }
}


struct MoonData: Codable, Identifiable {
    var moonrise: String
    var moonset: String
    var moonPhase: Float
    var moonPhasePercent: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: abs(moonPhase) as NSNumber) ?? ""
    }
    var moonPhaseDesc: String
    var utcTime: String
    var date: Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: utcTime) ?? Date()
    }
    
    var id: UUID { return UUID() }
    
    init() {
        moonrise = "9:00PM"
        moonset = "8:00AM"
        moonPhase = 1
        moonPhaseDesc = "Waning Gibbous"
        utcTime = ""
    }
}

struct MoonDataWrapper: Codable {
    var astronomy: [MoonData]
    
    init() {
        astronomy = [MoonData()]
    }
}

struct WeatherData: Codable {
    var description: String
    var skyDescription: String
    var temperature: String
    var temperatureDesc: String
    var comfort: String
    var highTemperature: String
    var lowTemperature: String
    var humidity: String
    var precipitation1H: String
    var precipitation: String {
        return (precipitation1H == "*") ? "0" : precipitation1H
    }
    var windSpeed: String
    
    init() {
        description = "Placeholder"
        skyDescription = "Placeholder"
        temperature = "50"
        temperatureDesc = "Placeholder"
        comfort = "50"
        highTemperature = "99"
        lowTemperature = "22"
        humidity = "50"
        precipitation1H = "*"
        windSpeed = "5"
    }
}

struct WeatherDataWrapper: Codable {
    var observation: [WeatherData]
    
    init() {
        observation = [WeatherData()]
    }
}

struct ConditionsData: Codable {
    var sun: SunDataWrapper
    var moon: MoonDataWrapper
    var conditions: WeatherDataWrapper
    
    init() {
        sun = SunDataWrapper()
        moon = MoonDataWrapper()
        conditions = WeatherDataWrapper()
    }
}

class FetchConditions: ObservableObject {
    @Published var conditions = ConditionsData()
    
    init() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let url = URL(string: "https://conditions.noahscholfield.com/?lat=40.451569&long=-79.953133&date=2020-09-05") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                  do {
                    let res = try decoder.decode(ConditionsData.self, from: data)
                    DispatchQueue.main.async {
                        self.conditions = res
                    }
                  } catch let error {
                     print(error)
                  }
              } else {
                print("NOTHING")
              }
           }.resume()
        }
    }
}


