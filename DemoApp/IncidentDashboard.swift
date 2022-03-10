//
//  IncidentDashboard.swift
//  DemoApp
//
//  Created by Nilesh Phadtare on 15/11/21.
//

import SwiftUI

struct IncidentDashboard: View {
    var body: some View {
        ZStack(alignment: .center, content: {
            ZStack(alignment: .trailing, content: {
                Image("")
                VStack {
                    VStack (alignment: .leading, spacing: 16, content: {
                        HStack(alignment: .top, spacing: 8, content: {
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
                            VStack{
                                Text("Current")
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                                Image(systemName: "arrow.down")
                                    .foregroundColor(Color.black)
                                    .imageScale(.medium)
                                Text("Next")
                                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.gray, lineWidth: 1)
                                    )
                            }
                        })
                        VStack(alignment: .leading, spacing: 8, content: {
                            HStack{
                                Text("Primary care maneger: ") + Text("Carol james")
                            }
                            HStack(alignment: .top, spacing: 0, content: {
                                Text("Note: ") + Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
                            })
                            HStack{
                                Button(action: {
                                    
                                }, label: {
                                    Text("+ Note")
                                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                                        //                                    .font(Font(FontUtility.shared.fontFor(type: .fieldTitle) as CTFont))
                                        .foregroundColor(Color.black)
                                        .overlay(
                                            Capsule()
                                                .stroke(Color.gray, lineWidth: 1)
                                        )
                                })
                                Divider().frame(height: 25)
                                Button(action: {
                                    
                                }, label: {
                                    Image(systemName: "phone.fill")
                                })
                                Spacer()
                            }
                        })
                        
                        HStack{
                            Button(action: {
                                
                            }, label: {
                                Text("+more")
                            })
                            Spacer()
                        }
                        
                    })
                    .padding()
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 12, content: {
                        Button(action: {
                            
                        }, label: {
                            Text("Last 1 year record")
                                .multilineTextAlignment(.leading)
                        })
                        
                        HStack (alignment: .center, spacing: 12, content: {
                            Button(action: {}, label: {
                                VStack(alignment: .center, spacing: 8, content: {
                                    Text("Total")
                                    Text("22")

                                })
                            })
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(8)
                            .shadow(color: Color.gray, radius: 5)

                            Button(action: {}, label: {
                                VStack(alignment: .center, spacing: 8, content: {
                                    Text("Total")
                                    Text("12")

                                })
                            })
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(8)
                            .shadow(color: Color.gray, radius: 5)

                            Button(action: {}, label: {
                                VStack(alignment: .center, spacing: 8, content: {
                                    Text("Total")
                                    Text("10")

                                })
                            })
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .cornerRadius(8)
                            .shadow(color: Color.gray, radius: 5)

                        })
                        .frame(maxWidth: .infinity)
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            })
        })
    }
}

struct IncidentDashboard_Previews: PreviewProvider {
    static var previews: some View {
        IncidentDashboard()
    }
}
