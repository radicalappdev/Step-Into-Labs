//  Step Into Vision - Labs
//
//  Title: Lab070
//
//  Subtitle:
//
//  Description:
//
//  Type:
//
//  Created by Joseph Simpson on 7/17/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab070: View {

    @State var dayOfYear: Int = 0
    
    // Helper function to get date string for a given day of year
    func getDateForDayOfYear(_ day: Int) -> String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // Create a date for the given day of year
        if let date = calendar.date(from: DateComponents(year: currentYear, day: day)) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            return "Day \(day): " + formatter.string(from: date)
        }
        
        return "Day \(day)"
    }

    var body: some View {
        VStackLayout().depthAlignment(.center) {
            YearCalendarView(currentDayOfYear: dayOfYear)
                .padding()

        }
        .ornament(attachmentAnchor: .scene(.topBack), ornament: {
            Text("Step Into Vision: 2025")
                .font(.largeTitle)
                .padding()
                .glassBackgroundEffect()
        })
        .ornament(attachmentAnchor: .scene(.bottom), ornament: {
            VStack {
                Text("Day of Year: \(dayOfYear)")
                               // Percentage of year complete
                Text("2025 is \(Int((Double(dayOfYear) / 365.0) * 100))% complete")
            }
                    .padding()
                    .glassBackgroundEffect()
        })
        .onAppear {
            let calendar = Calendar.current
            let today = Date()
            dayOfYear = calendar.ordinality(of: .day, in: .year, for: today) ?? 0
        }
    }
}



// MARK: - Calendar Views

fileprivate struct YearCalendarView: View {
    let currentDayOfYear: Int
    
    var body: some View {
        VStack(spacing: 8) {
            // Row 1: Jan, Feb, Mar
            HStack(alignment: .top, spacing: 8) {
                MonthView(month: 1, currentDayOfYear: currentDayOfYear)
                MonthView(month: 2, currentDayOfYear: currentDayOfYear)
                MonthView(month: 3, currentDayOfYear: currentDayOfYear)
            }
            
            // Row 2: Apr, May, Jun
            HStack(alignment: .top, spacing: 8) {
                MonthView(month: 4, currentDayOfYear: currentDayOfYear)
                MonthView(month: 5, currentDayOfYear: currentDayOfYear)
                MonthView(month: 6, currentDayOfYear: currentDayOfYear)
            }
            
            // Row 3: Jul, Aug, Sep
            HStack(alignment: .top, spacing: 8) {
                MonthView(month: 7, currentDayOfYear: currentDayOfYear)
                MonthView(month: 8, currentDayOfYear: currentDayOfYear)
                MonthView(month: 9, currentDayOfYear: currentDayOfYear)
            }
            
            // Row 4: Oct, Nov, Dec
            HStack(alignment: .top, spacing: 8) {
                MonthView(month: 10, currentDayOfYear: currentDayOfYear)
                MonthView(month: 11, currentDayOfYear: currentDayOfYear)
                MonthView(month: 12, currentDayOfYear: currentDayOfYear)
            }
        }
    }
}

fileprivate struct MonthView: View {
    let month: Int
    let currentDayOfYear: Int
    
    var body: some View {
        VStack(spacing: 4) {
            Text(getMonthName(month))
                .font(.caption)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(4)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 7), spacing: 1) {
                ForEach(0..<getFirstDayOfWeek(month), id: \.self) { _ in
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 16)
                }
                
                ForEach(getDaysInMonth(month), id: \.self) { day in
                    DayView(day: day, dayOfYear: getDayOfYear(month: month, day: day), currentDayOfYear: currentDayOfYear)
                }
            }
        }
        .frame(height: 120) // Fixed height for all months
        .padding(6)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    func getMonthName(_ month: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)) {
            return formatter.string(from: date)
        }
        return "Month \(month)"
    }
    
    func getDaysInMonth(_ month: Int) -> [Int] {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)),
           let range = calendar.range(of: .day, in: .month, for: date) {
            return Array(range)
        }
        return []
    }
    
    func getDayOfYear(month: Int, day: Int) -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: day)) {
            return calendar.ordinality(of: .day, in: .year, for: date) ?? 0
        }
        return 0
    }
    
    func getFirstDayOfWeek(_ month: Int) -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let date = calendar.date(from: DateComponents(year: currentYear, month: month, day: 1)) {
            return calendar.component(.weekday, from: date) - 1
        }
        return 0
    }
}

fileprivate struct DayView: View {
    let day: Int
    let dayOfYear: Int
    let currentDayOfYear: Int
    
    var body: some View {
        Text("\(day)")
            .font(.caption2)
            .fontWeight(.medium)
            .frame(width: 16, height: 16)
            .background(dayOfYear <= currentDayOfYear ? .stepGreen : .stepBackgroundSecondary)
            .cornerRadius(2)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .help(getDateForDayOfYear(dayOfYear))
    }
    
    func getDateForDayOfYear(_ day: Int) -> String {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        if let date = calendar.date(from: DateComponents(year: currentYear, day: day)) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd yyyy"
            return "Day \(day): " + formatter.string(from: date)
        }
        return "Day \(day)"
    }
}

#Preview {
    Lab070()
}
