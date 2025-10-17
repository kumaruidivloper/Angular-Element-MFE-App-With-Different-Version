import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.html',
  standalone: false,
  styleUrl: './app.scss'
})
export class App {
  protected title = 'host-app';

  message = '';

  ngOnInit() {
    this.loadMfeScript();
    this.listenForMessages();
    window.addEventListener('message', (event) => {
      if (event.data && event.data.from === 'mfe') {
        this.message = event.data.text;
      }
    });
  }

  loadMfeScript() {
    const scriptId = 'mfe-script';
    if (document.getElementById(scriptId)) return; // prevent duplicate loading

    const script = document.createElement('script');
    script.id = scriptId;
    script.type = 'module';
    script.src = 'http://localhost:4201/main.js';
    script.onload = () => {
      console.log('✅ MFE script loaded successfully!');
      this.renderMfeElement();
    };
    script.onerror = () => {
      console.error('❌ Failed to load MFE script.');
    };

    document.body.appendChild(script);
  }

  renderMfeElement() {
    const container = document.getElementById('mfe-container');
    if (container) {
      const mfeElement = document.createElement('mfe-widget');
      container.appendChild(mfeElement);
    }
  }

  listenForMessages() {
    window.addEventListener('message', (event) => {
      if (event.data?.from === 'mfe') {
        this.message = event.data.text;
      }
    });
  }

  sendToMFE() {
    window.postMessage({ from: 'host', text: 'Hello from Host!' }, '*');
  }

  
}
