//
//  CalendarUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//

import Foundation
import SwiftUI

protocol MonthViewUI {
    var showView: Bool {get set}
    var daySelected: Int {get set}
    var monthSelected: Int {get set}
    var YearSelected: Int {get set}
}


struct CalendarUI: View {

    // only display the current year
    var currentYear = Calendar.current.component(.year, from: Date())
    @State var currentDisplay = "kcksnd"
    
    var body: some View {
        ScrollView {
            ScrollViewReader { scrollView in
                LazyVStack {
                    WinterView(currentYear: currentYear)
                    SpringView(currentYear: currentYear)
                    SummerView(currentYear: currentYear)
                    FallView(currentYear: currentYear)
                }
            }
        }
    }
    
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("Testing numDays: " + String(numDays))
        return numDays
    }
    

}

struct WinterView: View {
    var currentYear: Int
    var body: some View {
        Text("January").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JanuaryView(numDays: dates(year: currentYear, month: 1), currentYear: currentYear)
        Text("Feburary").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        FeburaryView(numDays: dates(year: currentYear, month: 2), currentYear: currentYear)
        Text("March").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        MarchView(numDays: dates(year: currentYear, month: 3), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("Testing numDays: " + String(numDays))
        return numDays
    }
}
struct SpringView: View {
    var currentYear: Int
    var body: some View {
        Text("April").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        AprilView(numDays: dates(year: currentYear, month: 4), currentYear: currentYear)
        Text("May").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        MayView(numDays: dates(year: currentYear, month: 5), currentYear: currentYear)
        Text("June").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JuneView(numDays: dates(year: currentYear, month: 6), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("Testing numDays: " + String(numDays))
        return numDays
    }
}
struct SummerView: View {
    var currentYear: Int
    var body: some View {
        Text("July").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JulyView(numDays: dates(year: currentYear, month: 7), currentYear: currentYear)
        Text("August").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        AugustView(numDays: dates(year: currentYear, month: 8), currentYear: currentYear)
        Text("September").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        SeptemberView(numDays: dates(year: currentYear, month: 9), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("Testing numDays: " + String(numDays))
        return numDays
    }
}
struct FallView: View {
    var currentYear: Int
    var body: some View {
        Text("October").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        OctoberView(numDays: dates(year: currentYear, month: 10), currentYear: currentYear)
        Text("Novemeber").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        NovemberView(numDays: dates(year: currentYear, month: 11), currentYear: currentYear)
        Text("December").font(.title)
        Divider().frame(height: 2).background(Color(UIColor.darkGray))
        DecemberView(numDays: dates(year: currentYear, month: 12), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        print("Testing numDays: " + String(numDays))
        return numDays
    }
}


struct JanuaryView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1

    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 1, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
            
        }.onAppear {
            var date = String(currentYear) + "/01/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct FeburaryView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 2, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/02/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct MarchView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 3, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/03/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct AprilView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 4, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/04/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct MayView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 5, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/05/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct JuneView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 6, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/06/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}


struct JulyView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 7, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/07/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct AugustView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 8, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/08/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct SeptemberView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 9, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/09/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct OctoberView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 10, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/10/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct NovemberView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 11, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/11/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct DecemberView: View, MonthViewUI {
    
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 12, currentYear: currentYear, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            var date = String(currentYear) + "/12/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        print(weekday)
        return weekday
    }
}

struct dayCircles: View {
    var week: Int
    var day: Int
    var dayOfTheWeek: Int
    var circlefill = ".circle.fill"
    var numDays: Int
    var currentMonth: Int
    var currentYear: Int
    @State var parentView: MonthViewUI
    @State private var showDate = false
    var body: some View {
        if (((week - 1)*7 + day - dayOfTheWeek + 1) <= numDays) {
            getImage()
        } else {
            Image(systemName: "0.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
        }
        
    }
    
    private func getImage() -> some View {
        let number = ((week - 1)*7 + day - dayOfTheWeek + 1)
        let dateString = String(currentMonth) + "/" + String(number) + "/" + String(currentYear)
        let defaults = UserDefaults.standard
        let actualDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let currentDateTime = formatter.date(from: dateString)
        var isFutureButton = false
        
        if (currentDateTime! > actualDate) {
            isFutureButton = true
        }
        
        return Button(action: {
            //self.openView.toggle()
            if (number != parentView.daySelected || currentMonth != parentView.monthSelected || currentYear != currentYear) {
                parentView.showView = true
            } else {
                parentView.showView = false
                parentView.daySelected = -1
                parentView.monthSelected = -1
                parentView.YearSelected = -1
                return
            }
            parentView.daySelected = number
            parentView.monthSelected = currentMonth
            parentView.YearSelected = currentYear
        }) {
            if let surveyFilledStatus = defaults.string(forKey: dateString) {
                Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.systemGreen))
            } else {
                if (currentDateTime! < actualDate) {
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.systemRed))
                } else {
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.lightGray))
                }
            }
        }
        .disabled(isFutureButton)
    }
    

}
