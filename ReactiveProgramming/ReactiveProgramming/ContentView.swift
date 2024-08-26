//
//  ContentView.swift
//  ReactiveProgramming
//
//  Created by Three Bros on 26/8/24.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .onAppear(perform: {
            let iOS = 1
            let android = 2
            let flutter = 3
            
            let observable2 = Observable.of(iOS, android, flutter)
            
            observable2.subscribe(onNext: { (value) in
                    print(value)
                }, onError: { (error) in
                    print(error.localizedDescription)
                }, onCompleted: {
                    print("Completed")
                }) {
                    print("Disposed")
                }
            
            let observable = Observable<Void>.empty()
            
            observable.subscribe(
              onNext: { element in
                print(element)
            },
              onCompleted: {
                print("Completed")
              }
            )
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
