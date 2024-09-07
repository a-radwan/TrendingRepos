//
//  DateFilter.swift
//  TrendingRepos
//
//  Created by Ahd on 9/8/24.
//

import Foundation

enum DateFilter: String, CaseIterable {
    case lastDay = "Last Day"
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    
    var queryDateParameter: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        let date: Date
        
        switch self {
        case .lastDay:
            date = calendar.date(byAdding: .day, value: -1, to: Date())!
        case .lastWeek:
            date = calendar.date(byAdding: .weekOfYear, value: -1, to: Date())!
        case .lastMonth:
            date = calendar.date(byAdding: .month, value: -1, to: Date())!
        }
        
        return (dateFormatter.string(from: date))
    }
}
