//
//  ContentView.swift
//  Test
//
//  Created by Kumar Shan on 17/10/2025.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var messageFromMFE = ""
    @State private var webViewStore = WebViewStore()

    var body: some View {
        VStack(spacing: 20) {
            Text("iOS Host App")
                .font(.headline)

            Text("Message from MFE: \(messageFromMFE)")
                .padding()

            Button("Send Message to MFE") {
                sendMessageToMFE()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        
        WebView(
            messageFromMFE: $messageFromMFE,
            webViewStore: webViewStore,
            mfeUrl: "./main.js"
        )
        .frame(height: 400)
    }

    func sendMessageToMFE() {
        guard let webView = webViewStore.webView else {
            print("⚠️ WebView not ready yet")
            return
        }
        
        let script = """
        window.postMessage({ from: 'host', text: 'Hello from iOS Host!' }, '*');
        """
        
        webView.evaluateJavaScript(script) { result, error in
            if let error = error {
                print("❌ Error sending message: \(error.localizedDescription)")
            } else {
                print("✅ Message sent to MFE")
            }
        }
    }
}
