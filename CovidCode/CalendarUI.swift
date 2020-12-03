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

/*struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}*/


struct CalendarUI: View {
    
    var parentTabController: TabControllerUI
    // only display the current year
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    
    var body: some View {
        
        ScrollView {
            GeometryReader { geometry in
                if geometry.frame(in: .global).minY <= 0 {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .offset(y: geometry.frame(in: .global).minY/9)
                    .frame(width: geometry.size.width, height: geometry.size.height*4)
                } else {
                    TopBlueParralax().padding().background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
                    .frame(width: geometry.size.width, height: geometry.size.height*4 + geometry.frame(in: .global).minY)
                    .offset(y: -geometry.frame(in: .global).minY)
                }
            }
            TopCalendarView().padding().frame(width: UIScreen.main.bounds.width).background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 119/255, green: 158/255, blue: 203/255)))
            ScrollViewReader { scrollView in
                LazyVStack() {
                    WinterView(currentYear: currentYear, parentTabController: parentTabController)
                    SpringView(currentYear: currentYear, parentTabController: parentTabController)
                    SummerView(currentYear: currentYear, parentTabController: parentTabController)
                    FallView(currentYear: currentYear, parentTabController: parentTabController, scrollview: scrollView)
                }
                .onAppear {
                    withAnimation {
                        scrollView.scrollTo(currentMonth)

                    }
                }
            }
        }
        /*.toolbar {
            ToolbarItem(placement: .principal) {
                Image("test-banner")
                    .resizable()
                    .frame(height: 100)
                    
            }
        }*/
        /*.navigationTitle("Calendar Questionaire")
        .background(NavigationConfigurator { nc in
            nc.navigationBar.barTintColor = UIColor(cgColor: CGColor(red: 0, green: 161, blue: 242, alpha: 1.0))
                            nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
                        })*/
        
        
        
        
    }
    
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    

}

struct WinterView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var body: some View {
        Text("January").font(.title).fontWeight(.bold).id(1)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JanuaryView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 1), currentYear: currentYear)
        Text("Feburary").font(.title).fontWeight(.bold).id(2)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        FeburaryView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 2), currentYear: currentYear)
        Text("March").font(.title).fontWeight(.bold).id(3)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        MarchView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 3), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
struct SpringView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var body: some View {
        Text("April").font(.title).fontWeight(.bold).id(4)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        AprilView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 4), currentYear: currentYear)
        Text("May").font(.title).fontWeight(.bold).id(5)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        MayView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 5), currentYear: currentYear)
        Text("June").font(.title).fontWeight(.bold).id(6)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JuneView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 6), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
struct SummerView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var body: some View {
        Text("July").font(.title).fontWeight(.bold).id(7)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        JulyView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 7), currentYear: currentYear)
        Text("August").font(.title).fontWeight(.bold).id(8)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        AugustView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 8), currentYear: currentYear)
        Text("September").font(.title).fontWeight(.bold).id(9)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        SeptemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 9), currentYear: currentYear)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}
struct FallView: View {
    var currentYear: Int
    var parentTabController: TabControllerUI
    var scrollview : ScrollViewProxy
    var body: some View {
        Text("October").font(.title).fontWeight(.bold).id(10)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        OctoberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 10), currentYear: currentYear)
        Text("November").font(.title).fontWeight(.bold).id(11)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        NovemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 11), currentYear: currentYear)
        Text("December").font(.title).fontWeight(.bold).id(12)
        //Divider().frame(height: 2).background(Color(UIColor.darkGray))
        DecemberView(parentTabController: parentTabController, numDays: dates(year: currentYear, month: 12), currentYear: currentYear, scrollview: scrollview)
    }
    
    private func dates(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!

        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
}


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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 1, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected , parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 2, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 3, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 4, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 5, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 6, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}


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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 7, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 8, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 9, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 10, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 11, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
            if (showView) {
                CurrentDateInfoBoxUI(currentDay: daySelected, currentMonth: monthSelected, currentYear: YearSelected, parentTabController: parentTabController)
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
        return weekday
    }
}

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
            HStack {
            
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SUN"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("MON"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("TUE"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("WED"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("THU"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("FRI"))
                Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden().overlay(Text("SAT"))

                
            }
            ForEach(1...6, id: \.self) { week in
                HStack {
                    ForEach(1...7, id: \.self) { day in
                        if (!(week == 1 && day < dayOfWeek)) {
                            dayCircles(week: week, day: day, dayOfTheWeek: dayOfWeek, numDays: numDays, currentMonth: 12, currentYear: currentYear, parentView: self).padding(.bottom)
                        } else {
                            Image(systemName: "1.circle.fill").font(.system(size: 40, weight: .regular)).hidden()
                        }
                    
                    }
                }
            }
            
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
            var date = String(currentYear) + "/12/01"
            dayOfWeek = dayOfWeek(date: date)!
        }
        
    }

    
    private func dayOfWeek(date: String) -> Int? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        guard let dateDesired = formatter.date(from: date) else { return nil }
        let weekday = Calendar.current.component(.weekday, from: dateDesired)
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
        var isDisabledButton = false
        
        if (!Calendar.current.isDate(currentDateTime!, inSameDayAs: actualDate)) {
            isDisabledButton = true
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
                Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 119/255, green: 221/255, blue: 119/255))
            } else {
                if (currentDateTime! < actualDate) {
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(red: 250/255, green: 128/255, blue: 114/255))
                } else {
                    Image(systemName: String(number) + circlefill).font(.system(size: 40, weight: .regular)).foregroundColor(Color(UIColor.lightGray))
                }
            }
        }
        .disabled(isDisabledButton)
    }
    

}

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

