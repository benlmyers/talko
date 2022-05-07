//
//  ContentView.swift
//  talko
//
//  Created by Ben Myers on 5/6/22.
//

import SwiftUI
import EasyFirebase

struct ContentView: View {
    
    /// The user's inputted message
    @State var myMessage = ""
    /// All the stored messages
    @State var allMessages = [String]()
    
    var body: some View {
        VStack(spacing: 12.0) {
            Text("🌮 Talko!")
                .font(.title)
                .fontWeight(.black)
            HStack {
                TextField("🗣 Your message:", text: $myMessage)
                Button("Send") {
                    EasyFirestore.Retrieval.get(singleton: "TalkoData", ofType: TalkoData.self) { data in
                        if var data = data {
                            data.messages.append(myMessage)
                            EasyFirestore.Storage.set(data)
                        }
                    }
                }
            }
            Divider()
            Button("Refresh messages") {
                EasyFirestore.Retrieval.get(singleton: "TalkoData", ofType: TalkoData.self) { data in
                    if let data = data {
                        allMessages = data.messages
                    }
                }
            }
            .padding()
            ScrollView {
                VStack(spacing: 12.0) {
                    Text("All messages 📨").bold().foregroundColor(.yellow)
                    ForEach(allMessages.reversed(), id: \.self) { message in
                        Text(message).foregroundColor(.gray)
                    }
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
