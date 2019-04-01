//
//  Date+Extension.swift
//  CoreDemo
//
//  Created by weiwei.li on 2019/1/21.
//  Copyright © 2019 dd01.leo. All rights reserved.
//

import Foundation

public extension Date {
    // 只初始化一次，多次初始化DateFormatter对性能会有损耗
   fileprivate static var outputFormatter = DateFormatter()

    /// 获取日
    /// 2019-01-21 06:24:16 +0000
    /// return 21
    var day: Int {
        return Date.day(date: self)
    }
    
    static func day(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.day, from: d)
    }
    
    /// 获取月
    /// 2019-01-21 06:26:18 +0000
    /// return 1
    var month: Int {
        return Date.month(date: self)
    }
    
    static func month(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: d)
    }
    
    /// 获取年
    /// 2019-01-21 06:26:18 +0000
    /// return 2019
    var year: Int {
        return Date.year(date: self)
    }

    static func year(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: d)
    }
    
    /// 获取时
    /// 2019-01-21 06:26:18 +0000
    /// return 14
    var hour: Int {
        return Date.hour(date: self)
    }

    static func hour(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.hour, from: d)
    }
    
    var minute: Int {
        return Date.minute(date: self)
    }
    
    static func minute(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.minute, from: d)
    }
    
    /// 获取秒
    /// 2019-01-21 06:26:18 +0000
    /// return 2
    var second: Int {
        return Date.second(date: self)
    }
    
    static func second(date d: Date) -> Int {
        let calendar = Calendar.current
        return calendar.component(.second, from: d)
    }
    
    /// 获取星期几
    /// 周日--周六分别为 1---7
    var weekday: Int {
        return Date.weekday(self)
    }

    static func weekday(_ fromDate: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.component(.weekday, from: fromDate)
    }
    
    /// 是否为闰年
    var isLeapYear: Bool {
        return Date.isLeapYear(date: self)
    }

    static func isLeapYear(date d: Date) -> Bool {
        let year = d.year
        if (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0) {
            return true
        }
        return false
    }
    
    /// 获取全年天数
    var daysInYear: Int {
        return Date.daysInYear(date: self)
    }

    static func daysInYear(date d: Date) -> Int {
        return self.isLeapYear(date: d) ? 366: 365
    }
    
    /// 获取当前日期是当年的第几周
    var weekOfYear: Int {
        return Date.weekOfYear(date: self)
    }

    static func weekOfYear(date d: Date) -> Int {
        var i = 1
        let year = d.year
        while d.dateAfterDay(-7 * i).year == year {
            i += 1
        }
        
        return i
    }
    
    /// 返回当前月一共有几周(可能为4,5,6)
    var weeksOfMonth: Int {
        return Date.weeksOfMonth(date: self)
    }
    
    static func weeksOfMonth(date d: Date) -> Int {
        return d.lastdayOfMonth.weekOfYear - d.begindayOfMonth.weekOfYear + 1
    }
   
    /// 获取该月的第一天的日期
    var begindayOfMonth: Date {
        return Date.begindayOfMonth(date: self)
    }
    
    static func begindayOfMonth(date d: Date) -> Date {
        return dateAfterDay(d, day: -(d.day) + 1)
    }
    
    /// 获取该月的最后一天的日期
    var lastdayOfMonth: Date {
        return Date.lastdayOfMonth(date: self)
    }
    
    static func lastdayOfMonth(date d: Date) -> Date {
        let lastDate = begindayOfMonth(date: d)
        return lastDate.dateAfterMonth(1).dateAfterDay(-1)
    }
    
    /// 返回day天后的日期(若day为负数,则为|day|天前的日期)
    ///
    /// - Parameter day: 天数
    func dateAfterDay(_ day: Int) -> Date {
        return Date.dateAfterDay(self, day: day)
    }
    
    static func dateAfterDay(_ fromDate: Date, day: Int) -> Date {
        let calendar = Calendar.current
        var componentsToAdd = DateComponents()
        componentsToAdd.setValue(day, for: .day)
        let dateAfterDay = calendar.date(byAdding: componentsToAdd, to: fromDate) ?? Date()
        return dateAfterDay
    }
    
    /// 返回month月后的日期(若day为负数,则为|month|月前的日期)
    ///
    /// - Parameters:
    ///   - date: date
    ///   - month: 月
    /// - Returns: Date
    func dateAfterMonth(_ month: Int) -> Date {
        return Date.dateAfterMonth(self, month: month)
    }
    
    static func dateAfterMonth(_ fromDate: Date, month: Int) -> Date {
        let calendar = Calendar.current
        var componentsToAdd = DateComponents()
        componentsToAdd.setValue(month, for: .month)
        return calendar.date(byAdding: componentsToAdd, to: fromDate) ?? Date()
    }
    
    /// 返回Years年后的日期
    ///
    /// - Parameter years: 年数
    /// - Returns: Date
    func dateAfterYears(_ years: Int) -> Date {
       return Date.dateAfterYears(self, years: years)
    }

    static func dateAfterYears(_ fromDate: Date, years: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.setValue(years, for: .year)
        return calendar.date(byAdding: offsetComponents, to: fromDate) ?? Date()
    }

    /// 返回hours小时后的日期
    func dateAfterHours(_ hours: Int) -> Date {
        return Date.dateAfterHours(self, hours: hours)
    }

    static func dateAfterHours(_ fromDate: Date, hours: Int) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var offsetComponents = DateComponents()
        offsetComponents.setValue(hours, for: .hour)
        return calendar.date(byAdding: offsetComponents, to: fromDate) ?? Date()
    }
    
    /// 判断是否为同一天
    ///
    /// - Parameter date: anotherDate
    /// - Returns: Bool
    func isSameDay(anotherDate date: Date) -> Bool {
       return Date.isSameDay(self, anotherDate: date)
    }

    static func isSameDay(_ fromDate: Date, anotherDate date: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: fromDate)
        let components2 = calendar.dateComponents([.year, .month, .day], from: date)
        return (components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day)
    }
    
    /// 是否是今天
    var isToday: Bool {
        return Date.isSameDay(self, anotherDate: Date())
    }
    
    /// 获取格式化为YYYY-MM-dd格式的日期字符串
    /// 2019年01月21日
    var formatYMD: String {
        return Date.formatYMD(date: self)
    }
    
    static func formatYMD(date d: Date) -> String {
        return String(format: "%d年%02lu月%02lu日",d.year,d.month,d.day)
    }
    
    /// 根据日期返回字符串
    /// YYYY/MM/dd HH:mm:ss  HH大写为24小时制，小写为12小时制
    /// - Parameter format: 格式化
    /// - Returns: String
    func stringWithFormat(_ format: String) -> String {
        return Date.stringWithDate(self, format: format)
    }

    static func stringWithDate(_ date: Date, format: String) -> String {
        outputFormatter.dateFormat = format
        return outputFormatter.string(from: date)
    }
    
    /// 根据时间字符串获取Date
    ///
    /// - Parameters:
    ///   - string: 字符串
    ///   - format: 格式化
    /// - Returns: Date
    static func dateWithString(_ string: String, format: String) -> Date {
        outputFormatter.dateFormat = format
        return outputFormatter.date(from: string) ?? Date()
    }
    
    /// 获取指定月份的天数
    func daysInMonth(_ month: Int) -> Int {
        return Date.daysInMonth(self, month: month)
    }
    
    static func daysInMonth(_ fromDate: Date, month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 9, 10, 12:
            return 31
        case 2:
            return fromDate.isLeapYear ? 29 : 28
        default:
            return 30
        }
    }

    /// 分别获取yyyy-MM-dd/HH:mm:ss/yyyy-MM-dd HH:mm:ss格式的字符串
    var ymdFormat: String {
        return Date.ymdFormat()
    }
    
    static func ymdFormat() -> String {
        return "yyyy-MM-dd"
    }
    
    var hmsFormat: String {
        return Date.hmsFormat()
    }
    
    static func hmsFormat() -> String {
        return "HH:mm:ss"
    }
    
    var ymdHmsFormat: String {
        return Date.ymdHmsFormat()
    }
    
    static func ymdHmsFormat() -> String {
        return "\(self.ymdFormat()) \(self.hmsFormat())"
    }
    
}

