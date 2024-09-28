//
//  Date+Ext.swift
//  VKFeed
//
//  Created by Nurbek on 28/09/24.
//

import Foundation

extension Date {
    
    public func toPostDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy | HH:mm"
        
        return formatter.string(from: self)
    }
    
}
