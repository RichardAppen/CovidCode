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
}

struct CalendarUI: View {

    // only display the current year
    var currentYear = Calendar.current.component(.year, from: Date())
    @State var currentDisplay = "kcksnd"
    
    var body: some View {
        ScrollView {
            VStack {
                WinterView(currentYear: currentYear)
                SpringView(currentYear: currentYear)
                SummerView(currentYear: currentYear)
                FallView(currentYear: currentYear)
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

    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
    var body: some View {
        VStack {
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, parentView: self)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            if (showView) {
                CurrentDateInfoBoxUI()
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
    
        
        return Button(action: {
            //self.openView.toggle()
            parentView.showView.toggle()
        }) {
            Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.systemBlue))
        }
    }
}
