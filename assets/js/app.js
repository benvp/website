// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "./vendor/some-package.js"
//
// Alternatively, you can `npm install some-package` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import 'phoenix_html';
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import topbar from 'topbar';

import { animate, spring } from 'motion';

// Syntax highlighting
import Prism from './prism';

const hooks = {
  Prism: {
    mounted() {
      Prism.highlightAll(document.querySelector('pre code'));
    },
  },
  Motion: {
    getConfig() {
      return this.el.dataset.motion ? JSON.parse(this.el.dataset.motion) : undefined;
    },
    animate() {
      const { keyframes, transition } = this.getConfig() || {};

      console.log(transition, keyframes);
      if (transition?.__easing?.[0] === 'spring') {
        const {
          __easing: [_, options],
          ...t
        } = transition;

        animate(this.el, keyframes, { ...t, easing: spring(options) });
      } else {
        animate(this.el, keyframes, transition);
      }
    },
    mounted() {
      this.animate();
    },
    updated() {
      this.animate();
    },
  },
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
let liveSocket = new LiveSocket('/live', Socket, {
  params: { _csrf_token: csrfToken },
  hooks,
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.dataset.motion) {
        if (from.getAttribute('style') === null) {
          to.removeAttribute('style');
        } else {
          to.setAttribute('style', from.getAttribute('style'));
        }
      }
    },
  },
});

window.addEventListener('benvp:animate', (e) => {});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: '#00FFBF' }, shadowColor: 'rgba(0, 0, 0, .3)' });
let topBarScheduled = undefined;

window.addEventListener('phx:page-loading-start', () => {
  if (!topBarScheduled) {
    topBarScheduled = setTimeout(() => topbar.show(), 500);
  }
});

window.addEventListener('phx:page-loading-stop', () => {
  clearTimeout(topBarScheduled);
  topBarScheduled = undefined;
  topbar.hide();
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
