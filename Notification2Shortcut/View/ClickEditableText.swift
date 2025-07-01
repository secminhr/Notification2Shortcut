//
//  ClickEditableText.swift
//  Notification2Shortcut
//
//  Created by secminhr on 2025/7/1.
//
import SwiftUI

struct ClickEditableText: View {
    @State private var editing = false
    @Binding var text: String
    let prompt: String?
    
    init(text: Binding<String>, prompt: String? = nil) {
        self._text = text
        self.prompt = prompt
    }
    
    var body: some View {
        if editing {
            TextField(text: $text, prompt: Text(prompt ?? "")) {
                
            }
            .onSubmit {
                editing = false
            }
        } else {
            if text.isEmpty, let prompt = prompt {
                Text(prompt)
                    .foregroundStyle(.gray)
                    .onTapGesture {
                        editing = true
                    }
            } else {
                Text(text)
                    .onTapGesture {
                        editing = true
                    }
            }
        }
    }
}
