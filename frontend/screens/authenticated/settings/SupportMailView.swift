// SupportMailView.swift
// RealFlow
//
// Created by Aran Ali on 2024-04-13.

/*
 This view allows users to compose a support mail with a subject and message, choosing from predefined topics.
  Users can enter a subject, select a topic, compose a message, and send the mail.
  The view utilizes SwiftUI components such as Form, Picker, TextField, TextEditor, and Button.
 */


import SwiftUI

struct SupportMailView: View {
  @State private var subject: String = ""
  @State private var message: String = ""
 
    let supportTopics = [
      "Technical issues",
      "Feedback",
      "AccountQuestions",
      "Other questions",
    ]

  var body: some View {
      Form {
        Section(header: Text("ContactInformation")) {
         
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

