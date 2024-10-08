//
//  StatesList.swift
//  embrace-outdoors-ios
//
//  Created by David Rifkin on 8/13/24.
//

import Foundation

enum StatesList {
    static let all: [String:String] = [
        "Alabama": "AL",
        "Kentucky":"KY",
        "Ohio": "OH",
        "Alaska": "AK",
        "Louisiana": "LA",
        "Oklahoma": "OK",
        "Arizona": "AZ",
        "Maine": "ME",
        "Oregon": "OR",
        "Arkansas": "AR",
        "Maryland": "MD",
        "Pennsylvania": "PA",
        "American Samoa": "AS",
        "Massachusetts": "MA",
        "Puerto Rico": "PR",
        "California": "CA",
        "Michigan": "MI",
        "Rhode Island": "RI",
        "Colorado": "CO",
        "Minnesota": "MN",
        "South Carolina": "SC",
        "Connecticut": "CT",
        "Mississippi": "MS",
        "South Dakota": "SD",
        "Delaware": "DE",
        "Missouri": "MO",
        "Tennessee": "TN",
        "District of Columbia": "DC",
        "Montana": "MT",
        "Texas": "TX",
        "Florida": "FL",
        "Nebraska": "NE",
        "Georgia": "GA",
        "Nevada": "NV",
        "Utah": "UT",
        "Guam": "GU",
        "New Hampshire": "NH",
        "Vermont": "VT",
        "Hawaii": "HI",
        "New Jersey": "NJ",
        "Virginia": "VA",
        "Idaho": "ID",
        "New Mexico": "NM",
        "Virgin Islands": "VI",
        "Illinois": "IL",
        "New York": "NY",
        "Washington": "WA",
        "Indiana": "IN",
        "North Carolina": "NC",
        "West Virginia": "WV",
        "Iowa": "IA",
        "North Dakota": "ND",
        "Wisconsin": "WI",
        "Kansas": "KS",
        "Northern Mariana Islands": "MP",
        "Wyoming": "WY"
    ]
    
    static let allNames: [String] = Self.all.keys.sorted()
    
    static func getAbbrevFrom(name: String) -> String {
        Self.all[name] ?? ""
    }
}
