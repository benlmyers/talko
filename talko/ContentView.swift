//
//  ContentView.swift
//  talko
//
//  Created by Ben Myers on 5/6/22.
//

import SwiftUI
import EasyFirebase

struct ContentView: View {
    
    @State var myMessage = ""
    @State var allMessages = [String]()
    
    var body: some View {
        VStack {
            TextField("Your message:", text: $myMessage)
            Button("Send message") {
                let newMessage = "Hello, world!"
                EasyFirestore.Retrieval.get(singleton: "TalkoData", ofType: TalkoData.self) { data in
                    if var data = data {
                        data.messages.append(myMessage)
                        EasyFirestore.Storage.set(data)
                    }
                }
            }
            Button("Refresh messages") {
                EasyFirestore.Retrieval.get(singleton: "TalkoData", ofType: TalkoData.self) { data in
                    if let data = data {
                        allMessages = data.messages
                    }
                }
            }
            VStack {
                Text("All messages")
                ForEach(allMessages.reversed(), id: \.self) { message in
                    Text(message)
                }
            }
        }
        .padding()
        .onAppear {
            EasyFirebase.configure()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class TalkoData: Singleton {
    /// The id of the singleton; an auto-generated value.
    var id = "TalkoData"
    /// The date the singleton was created (will be the first time you launch the app!)
    var dateCreated = Date()
    /// The messages that have been sent by the user.
    var messages = [String]()
}
