//
//  DateHelper.swift
//  OMDB Client
//
//  Created by Prateek Pande on 28/09/18.
//  Copyright © 2018 Prateek Pande. All rights reserved.
//

import Foundation

struct DateHelper {
    
    static func calculateYearAgo(year: String)->String{
        let difference = calculateAgeDifference(year: year)
        if 0 == difference{
            return "recent"
        }
        else if difference < 0{
            return "upcoming"
        }
        return "\(difference) year" + (difference > 1 ? "s" : "") + " ago"
    }
    
    /*
     * @discussion This method calculates date difference in years
     * @param year: from date
     * @return age difference in years
     */
    static func calculateAgeDifference(year: String)->Int{
        let requiredYear = (year.split(separator: "–").last ?? Substring("")).description
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentDate = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: currentYear, month: 1, day: 2)
        let releaseYear = Int(requiredYear) ?? currentYear
        let releaseDate = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: releaseYear, month: 1, day: 2)
        return currentDate.date!.dateDifferenceInYears(fromDate: releaseDate.date!)
    }
}

extension Date{
    
    func dateDifferenceInYears(fromDate: Date)->Int{
        return Calendar.current.dateComponents([.year], from: fromDate, to: self).year ?? 0
    }
}
