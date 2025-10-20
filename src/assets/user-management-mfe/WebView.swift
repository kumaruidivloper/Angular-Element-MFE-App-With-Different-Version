import SwiftUI
import WebKit

// Store to hold WKWebView reference
class WebViewStore {
    var webView: WKWebView?
}

struct WebView: UIViewRepresentable {
    @Binding var messageFromMFE: String
    var webViewStore: WebViewStore
    var mfeUrl: String = "http://localhost:4201/main.js"
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "mfeToHost")
        
        // Allow arbitrary loads for localhost development
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        
        // Enable web inspector for debugging
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        
        // Store reference for later use
        webViewStore.webView = webView

        // Load HTML container that will bootstrap MFE
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { margin: 0; padding: 10px; font-family: system-ui; }
            #status, #mfe{ padding: 10px; background: #e3f2fd; margin-bottom: 10px; border-radius: 4px; }
                       #mfe{margin-top: 10px}
            #mfe-container {
                background: linear-gradient(135deg, #e3f2fd, #90caf9);
                padding: 20px;
                border-radius: 8px;
                min-height: 20px;
              }
                        mfe-widget {
        padding: 20px;
                        background: linear-gradient(135deg, #999999, #90caf9);
        }
          </style>
          
        </head>
        <body>
          <div id="status">Loading MFE...</div>
            <div id="mfe-container"></div>
          <div id="mfe"></div>
          <script type="module">
            console.log('📦 Starting MFE load from: \(mfeUrl)');
            
            // Import the MFE module
            import('\(mfeUrl)')
              .then(() => {
                console.log('✅ MFE script loaded');
                document.getElementById('status').textContent = 'MFE loaded successfully';
                
                // Create and append the web component
                setTimeout(() => {
                        const mfeEl = document.createElement('mfe-widget');
                        document.getElementById('mfe-container').appendChild(mfeEl);
                        console.log('✅ MFE widget created');
                        document.getElementById('mfe').textContent = 'MFE created successfully';
                },3000);
                
              })
              .catch(err => {
                console.error('❌ Failed to load MFE:', err);
                document.getElementById('status').textContent = 'Error loading MFE: ' + err.message;
                document.getElementById('status').style.background = '#ffebee';
              });

            // Host → MFE communication via postMessage
            window.addEventListener('message', (event) => {
              console.log('📨 Message received:', event.data);
              if (event.data.from === 'host') {
                const msg = document.createElement('p');
                msg.textContent = 'Host says: ' + event.data.text;
                msg.style.padding = '10px';
                msg.style.background = '#c8e6c9';
                msg.style.borderRadius = '4px';
                msg.style.marginTop = '10px';
                document.body.appendChild(msg);
              }
            });

            // MFE → Host communication
            window.sendMessageToHost = function(msg) {
              console.log('📤 Sending to host:', msg);
              window.webkit.messageHandlers.mfeToHost.postMessage(msg);
            };
          </script>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: URL(string: "http://localhost:4201/"))
               return webView
           }

           func updateUIView(_ uiView: WKWebView, context: Context) { }

           class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
               var parent: WebView

               init(_ parent: WebView) {
                   self.parent = parent
               }

               func userContentController(_ userContentController: WKUserContentController,
                                          didReceive message: WKScriptMessage) {
                   if message.name == "mfeToHost",
                      let text = message.body as? String {
                       print("📥 Received from MFE: \(text)")
                       parent.messageFromMFE = text
                   }
               }
               
               func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                   print("✅ WebView finished loading")
               }
               
               func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
                   print("❌ WebView failed: \(error.localizedDescription)")
               }
           }
       }

       #Preview {
           ContentView()
       }
