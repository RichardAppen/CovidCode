//
//  CalendarUI.swift
//  CovidCode
//
//  Created by Richard Appen on 11/20/20.
//
//  Display a custom calendar where today's dat can be clicked on to complete today's survey. Each day has
//  a color corresponding to whether or not the survey was completed on this day.
//

import Foundation
import SwiftUI

// Ensure that a MonthViewUI has these values
protocol MonthViewUI {
    var showView: Bool {get set}
    var daySelected: Int {get set}
    var monthSelected: Int {get set}
    var YearSelected: Int {get set}
}



struct CalendarUI: View {
    
    var parentTabController: TabControllerUI
    // only display the current year
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    var body: some View {
        
        ScrollView {
            // EXTENSION VIEW : Parallax Header
            Header()
            // EXTENSION VIEW
            TopCalendarView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            ScrollViewReader { scrollView in
                LazyVStack() {
                    // EXTENSION VIEW
                    WinterView(currentYear: currentYear, parentTabController: parentTabController)
                    // EXTENSION VIEW
                    SpringView(currentYear: currentYear, parentTabController: parentTabController)
                    // EXTENSION VIEW
                    SummerView(currentYear: currentYear, parentTabController: parentTabController)
                    // EXTENSION VIEW
                    FallView(currentYear: currentYear, parentTabController: parentTabController, scrollview: scrollView)
                }
                .onAppear {
                    withAnimation {
                        // Scroll to the current month so the user doesn't have to
                        scrollView.scrollTo(currentMonth)

                    }
                }
            }
        }
    }
}

// EXTENSION VIEW : display all the winter months
struct WinterView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var body: some View {
        Text("January").font(.title).fontWeight(.bold).id(1)
        // EXTENSION VIEW
        JanuaryView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 1), currentYear: currentYear)
        Text("Feburary").font(.title).fontWeight(.bold).id(2)
        // EXTENSION VIEW
        FeburaryView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 2), currentYear: currentYear)
        Text("March").font(.title).fontWeight(.bold).id(3)
        // EXTENSION VIEW
        MarchView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 3), currentYear: currentYear)
    }
    
    // Get the number of days in the given month
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}

// EXTENSION VIEW : display all the spring months
struct SpringView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var body: some View {
        Text("April").font(.title).fontWeight(.bold).id(4)
        // EXTENSION VIEW
        AprilView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 4), currentYear: currentYear)
        Text("May").font(.title).fontWeight(.bold).id(5)
        // EXTENSION VIEW
        MayView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 5), currentYear: currentYear)
        Text("June").font(.title).fontWeight(.bold).id(6)
        // EXTENSION VIEW
        JuneView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 6), currentYear: currentYear)
    }
    
    // Get the number of days in the given month
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}

// EXTENSION VIEW : display all the summer months
struct SummerView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    
    var body: some View {
        Text("July").font(.title).fontWeight(.bold).id(7)
        // EXTENSION VIEW
        JulyView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 7), currentYear: currentYear)
        Text("August").font(.title).fontWeight(.bold).id(8)
        // EXTENSION VIEW
        AugustView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 8), currentYear: currentYear)
        Text("September").font(.title).fontWeight(.bold).id(9)
        // EXTENSION VIEW
        SeptemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 9), currentYear: currentYear)
    }
    
    // Get the number of days in a given month
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}

// EXTENSION VIEW : Display the fall months
struct FallView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var scrollview : ScrollViewProxy
    var body: some View {
        Text("October").font(.title).fontWeight(.bold).id(10)
        // EXTENSION VIEW
        OctoberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 10), currentYear: currentYear)
        Text("November").font(.title).fontWeight(.bold).id(11)
        // EXTENSION VIEW
        NovemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 11), currentYear: currentYear)
        Text("December").font(.title).fontWeight(.bold).id(12)
        // EXTENSION VIEW
        DecemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 12), currentYear: currentYear, scrollview: scrollview)
    }
    
    // Get the number of days in a given month
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}

// EXTENSION VIEW : Display all days of January
struct JanuaryView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
        VStack() {
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))
                
            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 1, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected , parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
            
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/01/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
    
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of Feburary
struct FeburaryView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 2, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/02/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of March
struct MarchView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 3, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/03/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of April
struct AprilView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 4, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/04/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of May
struct MayView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 5, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/05/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of June
struct JuneView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 6, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/06/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of July
struct JulyView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 7, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/07/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of August
struct AugustView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 8, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/08/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of September
struct SeptemberView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 9, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/09/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of October
struct OctoberView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))
                
            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 10, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/10/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of November
struct NovemberView: View, MonthViewUI {
    var parentTabController: TabControllerUI
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
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 11, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer()
                Spacer()
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/11/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW : Display all days of December
struct DecemberView: View, MonthViewUI {
    var parentTabController: TabControllerUI
    var numDays: Int
    @State var dayOfWeek = 0
    var circlefill = ".circle.fill"
    @State var count = 1
    var currentYear: Int
    @State var showView: Bool = false
    @State var daySelected: Int = -1
    @State var monthSelected: Int = -1
    @State var YearSelected: Int = -1
    var scrollview: ScrollViewProxy
    
    var body: some View {
        VStack {
            // Days of the week header
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

            }
            
            // Grid of days in the month
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        // Make sure to start the first day on the right day of the week (M,T,W,T,F,S,S)
                        if (!(week == 1 && day < dayOfWeek)) {
                            // EXTENSION VIEW
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 12, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            // If there is no day at the current slot display an invisible circle to keep formatting
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            // Clicking on a day shows the CurrentDateInfoBoxUI for that day
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
                Spacer()
                Spacer().id(15)
                Spacer().onAppear {
                        print("test")
                        scrollview.scrollTo(15)
                    }
            }
        }.onAppear {
            //determine which weekday the first day of the month was
            let date = String(currentYear) + "/12/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    // Return which weekday the first day of the month was
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
        return weekday
    }
}

// EXTENSION VIEW :
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
        // If the current day for this circle is within the actual days in the month, then dispaly the circle
        if (((week - 1)*7 + day - dayOfTheWeek + 1) <= numDays) {
            getImage()
        
        // else display a hidden circle to keep fromatting in place
        } else {
            Image(systemName: "0.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
        }
        
    }
    
    // Get the actual circle to display
    private func getImage() -> some View {
        let number = ((week - 1)*7 + day - dayOfTheWeek + 1)
        let dateString = String(currentMonth) + "/" + String(number) + "/" + String(currentYear)
        let defaults = UserDefaults.standard
        let actualDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let currentDateTime = formatter.date(from: dateString)
        var isDisabledButton = false
        var isToday = false
        
        // Disable the button (circle) if it is not for today
        if (!Calendar.current.isDate(currentDateTime!, inSameDayAs: actualDate)) {
            isDisabledButton = true
        } else {
            isToday = true
        }
        
        return Button(action: {
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
            
            // User completed survey on this day so display the circle as green
            if defaults.string(forKey: dateString) != nil {
                if (isToday) {
                    
                    // If the circle if for today, add an extra black circle around it
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                        .clipShape(Circle())
                            .overlay(Circle().stroke(Color(UIColor.black), lineWidth: 3))
                } else {
                    
                    // Else don't add a black circle around it
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
                }
                
            // User did not complete their survey for today so display the circle as red
            } else {
                
                // If the circle came before today's actual date let it display it's completion color
                if (currentDateTime! < actualDate) {
                    if (isToday) {
                        
                        // Black outline if the circle was for today
                        Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                        .clipShape(Circle())
                            .overlay(Circle().stroke(Color(UIColor.black), lineWidth: 3))
                    } else {
                        
                        // No outline if not
                        Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                    }
                } else {
                    
                    // If we made it here it means we are in the future so make the circle gray
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.lightGray))
                }
            }
        }
        .disabled(isDisabledButton)     // disable any circle that isn't the circle for today
    }
    

}

// EXTENSION VIEW : An addition to the parallax blue header that adds calendar text
struct TopCalendarView: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("Calendar")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        
        }
    }
}

