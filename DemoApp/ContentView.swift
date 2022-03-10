//
//  ContentView.swift
//  DemoApp
//
//  Created by Nilesh Phadtare on 15/11/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ZStack(alignment: .top, content: {
            Image("download")
                .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                .aspectRatio(contentMode: .fill)
            VStack {
                VStack{
                    Text("Placeholder 2")
                }
                .frame(width: 300, height: 400)
                .background(Color.gray)
            } .padding(.top, 50)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
