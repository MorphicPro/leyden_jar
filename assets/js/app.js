// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'alpinejs'

import "phoenix_html"
import {Socket} from "phoenix"
import topbar from "topbar"
import {LiveSocket} from "phoenix_live_view"

let Hooks = {
  Chart: {
    mounted() {
      const self = this;

      import('chart.js').then(({ Chart, registerables }) => {
        Chart.register(...registerables)
        let ctx = 'myChart';
        let myChart = new Chart(ctx, {
          type: "line",
          data: {
            labels: [],
            datasets: [{
              label: 'amp',
              tension: 0.1,
              data: [],
              borderColor: 'rgb(75, 192, 192)',
              borderWidth: 1
            },
            {
              label: 'temp',
              tension: 0.1,
              data: [],
              borderColor: 'rgb(192, 75, 192)',
              borderWidth: 1
            }]
          },
          options: {
            scales: {
              y: {
                beginAtZero: true
              }
            }
          }
        })

        self.handleEvent("inital_data", ({ new_data }) => {
          let amps = new_data.map(({ amp }) => amp)
          let temps = new_data.map(({ temp }) => temp)
          console.debug(new_data)

          const data = myChart.data
          data.labels = amps.map(() => "")
          data.datasets[0].data = amps
          data.datasets[1].data = temps
          myChart.update()

        })
        self.handleEvent("push_data", ({ new_data }) => {
          let { amp, temp } = new_data
          const data = myChart.data
          data.labels.push("")
          data.datasets[0].data.push(amp)
          data.datasets[1].data.push(temp)
          myChart.update()
        })
        self.pushEvent("load-chart", {})
      })
    }
  }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, 
  {
    hooks: Hooks,
    params: {_csrf_token: csrfToken},
    dom: {
      onBeforeElUpdated(from, to){
        if(from.__x){ Alpine.clone(from.__x, to) }
      }
    }
  })
// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", info => topbar.show())
window.addEventListener("phx:page-loading-stop", info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket