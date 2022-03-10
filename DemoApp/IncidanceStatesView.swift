//
//  IncidanceStatesView.swift
//  DemoApp
//
//  Created by Nilesh Phadtare on 15/12/21.
//

import SwiftUI

struct IncidanceStatesView: View {
    
    struct Constants {
        static let serverDateFormat = "yyyy-MM-dd"
        static let title = "Incidents"
    }
    
    var allStates = [["name": "reported", "date": "2021-12-11", "actionBy": "lee ann le", "isCurrent": false, "notesCount": 2], ["name": "reported", "date": "2021-12-11", "actionBy": "lee ann le", "isCurrent": false, "notesCount": 0], ["name": "reported", "date": "2021-12-11", "actionBy": "lee ann le", "isCurrent": false, "notesCount": 0], ["name": "reported", "date": "2021-12-11", "actionBy": "lee ann le", "isCurrent": true, "notesCount": 0]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12, content: {
            VStack(alignment: .leading, spacing: 8, content: {
                Text("COPD")
                    .multilineTextAlignment(.leading)
                HStack{
                    Text("Reported On:")
                    
                    Text("26 oct, 2021")
                    Divider()
                        .frame(height: 30)
                        .padding()
                    Text("Priority:")
                    Text("5")
                    Spacer()
                }
            })
            ScrollView(.vertical, showsIndicators: false, content: {
                VStack(alignment: .center
                       , spacing: 0, content: {
                        ForEach(allStates.indices){ index in
                            let state = allStates[index]
                            HStack(alignment: .top, spacing: 0, content: {
                                if index == 0 {
                                    Rectangle()
                                        .fill(Color.clear)
                                        .frame(width: 3, height: 10, alignment: .center)
                                    
                                }
                                DetailView(state: state)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                                VStack(alignment: .center
                                       , spacing: 0, content: {
                                        if index == 0 {
                                            Rectangle()
                                                .fill(Color.clear)
                                                .frame(width: 3, height: 10, alignment: .center)
                                        }
                                        let isCurrent = (state["isCurrent"] as? Bool) ?? false
                                        if isCurrent == true {
                                            ZStack{
                                                Circle()
                                                    .fill(Color.white)
                                                    .frame(width: 20, height: 20, alignment: .center)
                                                    .shadow(color: Color.gray.opacity(0.5), radius: 5)
                                                Circle()
                                                    .fill(Color.blue)
                                                    .frame(width: 10, height: 10, alignment: .center)
                                            }
                                        } else {
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 10, height: 10, alignment: .center)
                                        }
                                        if index < allStates.count - 1 {
                                            Rectangle()
                                                .fill(Color.gray)
                                                .frame(width: 3, height: 80, alignment: .center)
                                        }
                                       })
                                    .frame(minWidth: 0, maxWidth: 10)
                                StateName(state: state)
                                    .frame(minWidth: 0, maxWidth: .infinity)
                            })
                            .frame(minWidth: 0, maxWidth: .infinity)
                        }
                       })
            })
        })
        .navigationBarTitle(Constants.title)
    }
}

struct StateName: View {
    var state: [String : Any]
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            let name = (state["name"] as? String) ?? ""
            Text(name)
                .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                .border(Color.gray, width: 1)
                .cornerRadius(2)
        })
    }
}

struct DetailView: View {
    var state: [String : Any]
    
    var body: some View {
        VStack(alignment: .trailing
               , spacing: 4, content: {
                let actionBy = (state["actionBy"] as? String) ?? ""
                Text(actionBy)
                    .foregroundColor(.gray)
                HStack{
                    let count = (state["notesCount"] as? Int) ?? 0
                    let date = (state["date"] as? String) ?? ""
                    
                    if count > 0 {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "note.text")
                                .imageScale(.small)
                        })
                        
                        Divider()
                            .background(Color.gray)
                            .frame(height: 20)
                    }
                    Text(date)
                        .foregroundColor(.black)
                }
               })
    }
}

struct IncidanceStatesView_Previews: PreviewProvider {
    static var previews: some View {
        IncidanceStatesView()
    }
}
