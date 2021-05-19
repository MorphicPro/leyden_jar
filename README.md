# [Leyden Jar](https://leydenjar.app)

Site: https://leydenjar.app

A simple EVSE dashboard for your OpenEVSE charger.

Implamenting the [emoncms](https://emoncms.org/site/api#input) api Leyden Jar can injest your data directly from your OpenEVSE device.
This allows you to persist your charge session data and compair it to other analyitic statsitc points such as the weather or your electric bill.

_Note: Early Development - 3/7/2021_
Check the roadmap below to see whats currently completed
### Basic Roadmap:
  - [X] Hosting
  - [X] CI
  - [ ] CD
  - [X] User registration
  - [X] Emoncms style API
  - [ ] Realtime Dash
  - [ ] Electric bill analysis
  - [ ] Push Notifications

[![CI](https://github.com/MorphicPro/leyden_jar/actions/workflows/CI.yml/badge.svg)](https://github.com/MorphicPro/leyden_jar/actions/workflows/CI.yml) [![CD](https://github.com/MorphicPro/leyden_jar/actions/workflows/CD.yml/badge.svg)](https://github.com/MorphicPro/leyden_jar/actions/workflows/CD.yml) [![Coverage Status](https://coveralls.io/repos/github/MorphicPro/leyden_jar/badge.svg?branch=main)](https://coveralls.io/github/MorphicPro/leyden_jar?branch=main)
### Development | Localhost

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Generate a local self signed cert with `mix phx.gen.cert` ("Be sure to add/trust it in your system")
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4001`](https://localhost:4001) from your browser.
