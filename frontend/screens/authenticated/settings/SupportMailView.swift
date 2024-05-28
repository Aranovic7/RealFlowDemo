//
//  SupportMailView.swift
//  RealFlow
//
//  Created by Aran Ali on 2024-04-13.
//

import SwiftUI

struct SupportMailView: View {
  @State private var subject: String = ""
  @State private var message: String = ""
 
    let supportTopics = [
      "Tekniska problem",
      "Feedback",
      "Kontofrågor",
      "Övriga frågor",
    ]

  var body: some View {
      Form {
        Section(header: Text("Kontaktinformation")) {
         
        }

        Section(header: Text("Subject")) {
            Picker("Choose a subject", selection: $subject) {
                ForEach(supportTopics, id: \.self) { topic in
                    Text(topic)
                }
            }
          TextField("subject..", text: $subject)
        }

        Section(header: Text("Message")) {
          TextEditor(text: $message)
        }

        Section {
          Button(action: {
            
          }) {
              HStack{
                  Spacer()
                  Text("Send")
                  Spacer()
              }
           
          }
        }
      }
  }

}




#Preview {
    SupportMailView()
}

