//
//  NPClaenderView.swift
//  DemoApp
//
//  Created by Nilesh Phadtare on 03/03/22.
//

import SwiftUI
struct NPContentView: View{
    @State var selectedDate = Date()
    var body: some View {
        NPCalenderView(content: {Text("Hello: \(selectedDate)").padding()}, dateSelectionAction:{ date in  selectedDate = date}).padding()
    }
}

struct NPCalenderView<Content: View>: View {
    @State var monthSelectedColor = Color.black
    @State var monthDefaultColor = Color.gray
    @State var monthFont = Font.system(size: 14).bold()
    @State var dayFont = Font.system(size: 16)
    @State var dayBgSelectedColor = Color.blue
    @State var dayBgDefaultColor = Color.clear
    @State var daySelectedColor = Color.white
    @State var dayDefaultColor = Color.black
    @State var dayWeekFont = Font.system(size: 9)
    @State private var selectedMonth: Int = CalenderModal().getMonthNumber(date: Date())
    @State private var selectedYear: String = "\(CalenderModal().getYear(date: Date()))"
    @State private var showPickerView: Bool = false
    @State private var dates = [[Any]]()
    @State private var selectedDay: Int = CalenderModal().getDayNumber(date: Date())
    @State var selectedDate: Date = Date()
    @State var minDate: Date = "01/01/1000".dateValue(format: "dd/MM/yyyy")
    @State var maxDate: Date = "31/12/9999".dateValue(format: "dd/MM/yyyy")
    @State var isSheetShowView: Bool = false
    @State private var yearsArray: [String] = ["\(CalenderModal().getYear(date: Date()))"]
    let content: Content?
    var dateSelectionAction: (_ date: Date) -> Void

    init(@ViewBuilder content: () -> Content, dateSelectionAction: @escaping (_ date: Date) -> Void) {
        self.content = content()
        self.dateSelectionAction = dateSelectionAction
    }
    
    func monthYearSelectedColor(_ color: Color) -> Self{
        var copy = self
        copy._monthSelectedColor = State(wrappedValue: color)
        return copy
    }
    func monthDefaultColor(_ color: Color) -> Self{
        var copy = self
        copy._monthDefaultColor = State(wrappedValue: color)
        return copy
    }
    func monthFont(_ font: Font) -> Self{
        var copy = self
        copy._monthFont = State(wrappedValue: font)
        return copy
    }
    func dayBgSelectedColor(_ color: Color) -> Self{
        var copy = self
        copy._dayBgSelectedColor = State(wrappedValue: color)
        return copy
    }
    func dayBgDefaultColor(_ color: Color) -> Self{
        var copy = self
        copy._dayBgDefaultColor = State(wrappedValue: color)
        return copy
    }
    func daySelectedColor(_ color: Color) -> Self{
        var copy = self
        copy._daySelectedColor = State(wrappedValue: color)
        return copy
    }
    func dayDefaultColor(_ color: Color) -> Self{
        var copy = self
        copy._dayBgDefaultColor = State(wrappedValue: color)
        return copy
    }
    func dayWeekFont(_ font: Font) -> Self{
        var copy = self
        copy._dayWeekFont = State(wrappedValue: font)
        return copy
    }
    func dayFont(_ font: Font) -> Self{
        var copy = self
        copy._dayFont = State(wrappedValue: font)
        return copy
    }

    func selectedDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._selectedMonth = State(wrappedValue: CalenderModal().getMonthNumber(date: date))
        copy._selectedYear = State(wrappedValue: "\(CalenderModal().getYear(date: date))")
        copy._selectedDay = State(wrappedValue: CalenderModal().getDayNumber(date: date))
        return copy
    }
    func minDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._minDate = State(wrappedValue: date)
        return copy
    }
    func maxDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._maxDate = State(wrappedValue: date)
        return copy
    }
    
    var body: some View {
        ZStack(alignment: .bottom, content: {
            VStack(alignment: .center, spacing: 2, content: {
                NPCalenderMonthsView(selectedMonth: selectedMonth, selectedYear: selectedYear, selectedDay: selectedDay, action: {
                    if UI_USER_INTERFACE_IDIOM() == .pad {
                        self.isSheetShowView = true
                    } else {
                        self.showPickerView = true
                    }
                }, actionMonth: { month in
                    if selectedMonth != month {
                        selectedDay = 1
                    } else if CalenderModal().getMonthNumber(date: selectedDate) == month{
                        selectedDay = CalenderModal().getDayNumber(date: selectedDate)
                    }
                    self.selectedMonth = month
                    DispatchQueue.main.async{
                        self.findWeeksAndDays()
                    }
                })
                .monthSelectedColor(monthSelectedColor)
                .monthDefaultColor(monthDefaultColor)
                .monthFont(monthFont)
                .minDate(minDate)
                .maxDate(maxDate)
                .frame(height: 35)
//                .padding()
                .popover(isPresented: $isSheetShowView, content: {
                    generalPickerSwiftUI(isShowView: $showPickerView, isSheetShow: $isSheetShowView, pickerDataSource: yearsArray, selectedValue: $selectedYear)
                })
                
                if self.dates.count > 0 {
                    NPCalenderDayScrollView(dayFont: dayFont, dayBgSelectedColor: dayBgSelectedColor, daySelectedColor: daySelectedColor, dayDefaultColor: dayDefaultColor, dayWeekFont: dayWeekFont, selectedMonth: selectedMonth, selectedYear: selectedYear, dates: dates, selectedDay: selectedDay, selectedDate: CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: selectedMonth, selectedYear: selectedYear)){ date in
                        self.selectedDate = date
                        dateSelectionAction(self.selectedDate)
                    }
                    .minDate(minDate)
                    .maxDate(maxDate)
                    .frame(height: 70)
                    .padding()
                } else {
                    EmptyView().frame(height: 70)
                }
                if let contentView = self.content{
                    contentView
                    Spacer()
                }
            })
            .onAppear(){
                self.findWeeksAndDays()
                self.yearsArray.removeAll()
                let firstYear = CalenderModal().getYear(date: minDate)
                let maxYear = CalenderModal().getYear(date: maxDate)
                for value in (firstYear...maxYear){
                    self.yearsArray.append("\(value)")
                }
            }
            if showPickerView {
                VStack{
                    generalPickerSwiftUI(isShowView: $showPickerView, isSheetShow: $isSheetShowView, pickerDataSource: yearsArray, selectedValue: $selectedYear)
                }
            }
        }).padding()
        
    }
    
    
    func findWeeksAndDays(){
        self.dates.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: {
            let count = CalenderModal().getNumberOfWeeks(date: CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: selectedMonth, selectedYear: selectedYear))
            for value in (1...count){
                let day = ((value - 1) * 7) + 1
                let dateString = "\(day)/\(selectedMonth)/\(selectedYear)"
                let dateStringFormatter = DateFormatter()
                dateStringFormatter.dateFormat = "d/M/yyyy"
                let someDateTime = dateStringFormatter.date(from: dateString) ?? Date()
                var days = CalenderModal().getWeek(selectedDate: someDateTime)
                dateStringFormatter.dateFormat = "M"
                days = days.filter({CalenderModal().getMonthNumber(date: $0) == selectedMonth})
                var finalArray: [Any] = [Any]()
                if days.count < 7 {
                    let extra = 7 - days.count
                    if value >= count{
                        finalArray.append(contentsOf: days)
                        let finalValue = days.count
                        for dy in (finalValue...(finalValue + extra - 1)) {
                            let dayString = CalenderModal().getDayStringBy(value: dy+1)
                            finalArray.append(dayString)
                        }
                    }
                    if value == 1 {
                        for dy in (1...extra) {
                            let dayString = CalenderModal().getDayStringBy(value: dy)
                            finalArray.append(dayString)
                        }
                        finalArray.append(contentsOf: days)
                    }
                } else {
                    let arr = days.filter({ CalenderModal().getMonthNumber(date: $0) == selectedMonth})
                    finalArray.append(contentsOf: arr)
                }
                self.dates.append(finalArray)
            }
        })
    }
}

struct NPCalenderMonthsView: View {
    
    @State var monthSelectedColor: Color = Color.gray
    @State var monthDefaultColor: Color = Color.black
    @State var monthFont: Font = Font.system(size: 14).bold()
    var selectedMonth: Int = CalenderModal().getMonthNumber(date: Date())
    var selectedYear: String = "\(CalenderModal().getYear(date: Date()))"
    var selectedDay: Int = CalenderModal().getDayNumber(date: Date())
    var action: () -> Void
    var actionMonth: (_ month: Int) -> Void
    @State var minDate: Date = "01/01/1000".dateValue(format: "dd/MM/yyyy")
    @State var maxDate: Date = "31/12/9999".dateValue(format: "dd/MM/yyyy")

    private let monthsArray = CalenderModal().getMonthsList()
    
    func monthSelectedColor(_ color: Color) -> Self{
        var copy = self
        copy._monthSelectedColor = State(wrappedValue: color)
        return copy
    }
    func monthDefaultColor(_ color: Color) -> Self{
        var copy = self
        copy._monthDefaultColor = State(wrappedValue: color)
        return copy
    }
    
    func monthFont(_ font: Font) -> Self{
        var copy = self
        copy._monthFont = State(wrappedValue: font)
        return copy
    }
    func minDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._minDate = State(wrappedValue: date)
        return copy
    }
    func maxDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._maxDate = State(wrappedValue: date)
        return copy
    }
    var body: some View {
        VStack{
            HStack{
                Button(action: action, label: {
                    Text("\(selectedYear) ▼")
                        .font(monthFont)
                        .foregroundColor(monthSelectedColor)
                }).padding(.horizontal, 10)
                Divider().frame(width: 2, height: 20)
                ScrollViewReader { value in
                    ScrollView(.horizontal) {
                        HStack(spacing: 0) {
                            ForEach(monthsArray.indices, id: \.self){ index in
                                Button(action: {
                                    if minDate <= CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: (index + 1), selectedYear: selectedYear), maxDate >= CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: (index + 1), selectedYear: selectedYear) {
                                        self.actionMonth((index + 1))
                                    }
                                }, label: {
                                    ZStack {
                                        if (index + 1) == selectedMonth{
                                            Text(monthsArray[index])
                                                .frame(width: UIScreen.main.bounds.width/5, height: 35, alignment: .center)
                                                .font(monthFont)
                                                .foregroundColor(monthSelectedColor)
                                            
                                        }else{
                                            Text(monthsArray[index])
                                                .frame(width: UIScreen.main.bounds.width/5, height: 35, alignment: .center)
                                                .font(monthFont)
                                                .foregroundColor(monthDefaultColor)
                                        }
                                    }
                                })
                                .id(index)
                                
                            }
                        }
                    }
                    .padding(.init(top: 1, leading: 1, bottom: 1, trailing: 5))
                    .onAppear(){
                        var index = selectedMonth - 1
                        if index < 0{
                            index = 0
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            value.scrollTo(index)
                        }
                    }
                }
                
            }.frame(height: 35)
            .padding()
        }.frame(height: 35)
    }
}

struct NPCalenderDayScrollView: View {
    
    @State private var dayBgDefaultColor = Color.clear
    @State var dayFont = Font.system(size: 16)
    @State var dayBgSelectedColor = Color.blue
    @State var daySelectedColor = Color.white
    @State var dayDefaultColor = Color.black
    @State var dayWeekFont = Font.system(size: 9)
    @State var selectedMonth: Int = CalenderModal().getMonthNumber(date: Date())
    @State var selectedYear: String = "\(CalenderModal().getYear(date: Date()))"
    @State var dates = [[Any]]()
    @State var selectedDay: Int = CalenderModal().getDayNumber(date: Date())
    @State var selectedDate: Date = Date()
    var action: (_ date: Date) -> Void
    @State var minDate: Date = "01/01/1000".dateValue(format: "dd/MM/yyyy")
    @State var maxDate: Date = "31/12/9999".dateValue(format: "dd/MM/yyyy")
    @State var selectedView = 0
    
    @State var index: Int = 0
    func minDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._minDate = State(wrappedValue: date)
        return copy
    }
    func maxDate(_ date: Date = Date())-> Self  {
        var copy = self
        copy._maxDate = State(wrappedValue: date)
        return copy
    }
    var body: some View {
        TabView(selection: $selectedView) {
            if self.dates.count > 0 {
                let count = self.dates.count
                ForEach((0..<count), id: \.self){ index in
                    let object = self.dates[index]
                    NPCalenderDayView(dayFont: dayFont, dayBgSelectedColor: dayBgSelectedColor, daySelectedColor: daySelectedColor, dayDefaultColor: dayDefaultColor, dayWeekFont: dayWeekFont, selectedMonth: selectedMonth, selectedYear: selectedYear, dates: object, selectedDay: selectedDay, selectedDate: selectedDate, minDate: minDate, maxDate: maxDate){ date in
                        self.selectedDate = date
                        action(date)
                    }
                    .tag(index)
                    .padding(.init(top: 10, leading: 5, bottom: 10, trailing: 5))
                }
            }
        }
        .onAppear(){
            let index = self.dates.firstIndex(where:{
                var isValid = false
                for object in $0 {
                    if let date = object as? Date, date.stringValue(format: "d/M/yyyy").dateValue(format: "d/M/yyyy") == CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: selectedMonth, selectedYear: selectedYear) {
                        isValid = true
                        break
                    }
                }
                return isValid
            }) ?? 0
            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                self.selectedView = index
            }
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width, height: 70)
        .clipped()
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

struct NPCalenderDayView: View {
    
    @State var dayFont = Font.system(size: 16)
    @State var dayBgSelectedColor = Color.blue
    @State private var dayBgDefaultColor = Color.clear
    @State var daySelectedColor = Color.white
    @State var dayDefaultColor = Color.black
    @State var dayWeekFont = Font.system(size: 9)
    @State var selectedMonth: Int = CalenderModal().getMonthNumber(date: Date())
    @State var selectedYear: String = "\(CalenderModal().getYear(date: Date()))"
    @State var dates = [Any]()
    @State var selectedDay: Int = CalenderModal().getDayNumber(date: Date())
    @State var selectedDate: Date = Date()
    @State var minDate: Date = "01/01/1000".dateValue(format: "dd/MM/yyyy")
    @State var maxDate: Date = "31/12/9999".dateValue(format: "dd/MM/yyyy")
    @State var index: Int = 0
    var action: (_ date: Date) -> Void

    var body: some View {
        HStack{
            ForEach(self.dates.indices, id: \.self) { index in
                let object = self.dates[index]
                if let day = object as? String {
                    VStack {
                        Text(day)
                            .font(dayWeekFont)
                            .foregroundColor(dayDefaultColor)
                        Text("0")
                            .font(dayFont)
                            .foregroundColor(.clear)
                            .padding(.top, 1)
                            .background(Color.gray).opacity(0.2)
                            .cornerRadius(10)
                    }
                    .background(dayBgDefaultColor)
                    .frame(width: UIScreen.main.bounds.width/8, height: 70, alignment: .center)
                    
                } else if let date = object as? Date {
                    if CalenderModal().getDayNumber(date: date) == selectedDay{
                        VStack{
                            VStack {
                                Text(CalenderModal().getDayShort(date: date).prefix(1))
                                    .font(dayWeekFont)
                                    .foregroundColor(daySelectedColor)
                                Text("\(CalenderModal().getDayNumber(date: date))")
                                    .font(dayFont)
                                    .foregroundColor(daySelectedColor)
                                    .padding(.top, 1)
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(dayBgSelectedColor)
                            .cornerRadius(25)
                        }
                        .frame(width: UIScreen.main.bounds.width/8, height: 70, alignment: .center)
                        .foregroundColor(Color.white)
                        
                    }else{
                        Button(action: {
                            if minDate <= CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: (index + 1), selectedYear: selectedYear), maxDate >= CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: (index + 1), selectedYear: selectedYear) {
                                selectedDay = CalenderModal().getDayNumber(date: date)
                                self.selectedDate = CalenderModal().selectedDateOnAction(selectedDay: selectedDay, selectedMonth: selectedMonth, selectedYear: selectedYear)
                                action(self.selectedDate)
                            }
                        }, label: {
                            VStack {
                                Text(CalenderModal().getDayShort(date: date).prefix(1))
                                    .font(dayWeekFont)
                                    .foregroundColor(dayDefaultColor)
                                Text("\(CalenderModal().getDayNumber(date: date))")
                                    .font(dayFont)
                                    .foregroundColor(dayDefaultColor)
                                    .padding(.top, 1)
                            }
                            .background(dayBgDefaultColor)
                            .frame(width: UIScreen.main.bounds.width/8, height: 70, alignment: .center)
                        })
                    }
                } else{
                    EmptyView()
                }
            }
        } .padding()
    }
}


class CalenderModal: ObservableObject{
    
    func selectedDateOnAction(selectedDay: Int, selectedMonth: Int, selectedYear: String) -> Date{
        let dateString = "\(selectedDay)/\(selectedMonth)/\(selectedYear)"
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "d/M/yyyy"
        let someDateTime = dateStringFormatter.date(from: dateString) ?? Date()
        return someDateTime
    }
    
    func getMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    func getDayShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func getDayNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }
    
    func getCurrentDayOfMonth(date: Date) -> Int{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }
    
    func getWeek(selectedDate: Date = Date()) -> [Date] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: selectedDate)
        let dayOfWeek = calendar.component(.weekday, from: today)
        let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
        let days = ((weekdays.lowerBound) ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
        return days
    }
    
    func getMonthNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: date)
        return components.month ?? 0
    }
    
    func getYear(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        return components.year ?? 0
    }
    
    func getNumberOfWeeks(date: Date) -> Int{
        let calendar = Calendar.current
        let weekRange = calendar.range(of: .weekOfMonth,
                                       in: .month,
                                       for: date)
        let weeksCount = weekRange?.count ?? 0
        return weeksCount
    }
    
    func getDayStringBy(value: Int) -> String {
        switch value {
            case 1: return "S"
            case 2: return "M"
            case 3: return "T"
            case 4: return "W"
            case 5: return "T"
            case 6: return "F"
            case 7: return "S"
            default: return ""
        }
    }
    
    func getMonthsList() -> [String] {
        let dateFormatter = DateFormatter()
        var monthArr: [String] = []
        for months in 0..<12 {
            monthArr.append("\(dateFormatter.shortMonthSymbols[months])")
        }
        return monthArr
    }
}

struct generalPickerSwiftUI: View {
    
    struct Constants {
        static let btnCancelTitle = "Cancel"
        static let btnDoneTitle = "Done"
    }
    @Binding var isShowView: Bool
    @Binding var isSheetShow: Bool
    var pickerDataSource: [String]?
    @Binding var selectedValue: String

    var body: some View{
        VStack {
            HStack{
                Spacer()
                Button(action: {
                    self.isShowView = false
                    self.isSheetShow = false
                }, label: {
                    Text(Constants.btnDoneTitle)
                }).padding()
            } .padding(.horizontal, 8)
            Divider().frame(width: UIScreen.main.bounds.size.width-20, height: 0.5)
                .background(Color.gray).opacity(0.3)
            HStack(alignment: .bottom) {
                if let arrayValue = pickerDataSource {
                    Picker("", selection: $selectedValue) {
                        ForEach(arrayValue, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }
        }
        .background(Color.white.opacity(0.95))
        .transition(.move(edge: .bottom))
    }
}

// MARK: - Date
extension Date {
    func stringValue(format: String, use12HourFormat: Bool = true) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = format
        if use12HourFormat {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        return dateFormatter.string(from: self)
    }
}

extension String {
    // date information
    func dateValue(format: String, use12HourFormat: Bool = true) -> Date {
        let dateFormatter = DateFormatter()
        if use12HourFormat {
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        }
        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = format
        let dateString = self
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                return date
            } else {
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "MMM dd, yyyy"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "hh:mm a"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
                dateFormatter.dateFormat = "HH:mm"
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }else{
                    return Date()
                }
            }
        }
    }
}
