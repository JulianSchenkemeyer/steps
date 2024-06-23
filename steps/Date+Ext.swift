//
//  Date+Ext.swift
//  steps
//
//  Created by Julian Schenkemeyer on 23.06.24.
//

import Foundation


extension Date {
    var weekdayInt: Int {
        Calendar.current.component(.weekday, from: self)
    }
}
