//
//  Weather.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
    let currently: Currently?
    let minutely: Minutely?
    let hourly: Hourly?
    let daily: Daily?
    let flags: Flags?
    let offset: Int?
}

struct Currently: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let nearestStormDistance: Int?
    let precipIntensity: Double?
    let precipIntensityError: Double?
    let precipProbability: Double?
    let precipType: String?
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility: Double?
    let ozone: Double?
}

struct Daily: Codable {
    let summary: String?
    let icon: String?
    let data: [DailyDatum]?
}

struct DailyDatum: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let sunriseTime: Int?
    let sunsetTime: Int?
    let moonPhase: Double?
    let precipIntensity: Double?
    let precipIntensityMax: Double?
    let precipIntensityMaxTime: Int?
    let precipProbability: Double?
    let precipType: String?
    let temperatureHigh: Double?
    let temperatureHighTime: Int?
    let temperatureLow: Double?
    let temperatureLowTime: Int?
    let apparentTemperatureHigh: Double?
    let apparentTemperatureHighTime: Int?
    let apparentTemperatureLow: Double?
    let apparentTemperatureLowTime: Int?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windGust: Double?
    let windGustTime: Int?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let uvIndexTime: Int?
    let visibility: Double?
    let ozone: Double?
    let temperatureMin: Double?
    let temperatureMinTime: Int?
    let temperatureMax: Double?
    let temperatureMaxTime: Int?
    let apparentTemperatureMin: Double?
    let apparentTemperatureMinTime: Int?
    let apparentTemperatureMax: Double?
    let apparentTemperatureMaxTime: Int?
}

struct Flags: Codable {
    let sources: [String]?
    let isdStations: [String]?
    let units: String?
}

struct Hourly: Codable {
    let summary: String?
    let icon: String?
    let data: [HourlyDatum]?
}

struct HourlyDatum: Codable {
    let time: Int?
    let summary: String?
    let icon: String?
    let precipIntensity: Double?
    let precipProbability: Double?
    let temperature: Double?
    let apparentTemperature: Double?
    let dewPoint: Double?
    let humidity: Double?
    let pressure: Double?
    let windSpeed: Double?
    let windGust: Double?
    let windBearing: Int?
    let cloudCover: Double?
    let uvIndex: Int?
    let visibility: Double?
    let ozone: Double?
    let precipType: String?
}

struct Minutely: Codable {
    let summary: String?
    let icon: String?
    let data: [MinutelyDatum]?
}

struct MinutelyDatum: Codable {
    let time: Int?
    let precipIntensity: Double?
    let precipIntensityError: Double?
    let precipProbability: Double?
    let precipType: String?
}
