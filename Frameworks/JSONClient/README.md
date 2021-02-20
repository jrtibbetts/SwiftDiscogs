# JSONClient
[![Build Status](https://travis-ci.org/jrtibbetts/JSONClient.svg?branch=master)](https://travis-ci.org/jrtibbetts/JSONClient)
![Swift 4.0](https://img.shields.io/badge/Swift-4.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![CodeCov](https://img.shields.io/codecov/c/github/jrtibbetts/JSONClient.svg)
[![Codebeat](https://codebeat.co/badges/9db4672f-1ffc-4981-a7d0-3bb71e97cd62)](https://codebeat.co/projects/github-com-jrtibbetts-jsonclient-master)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

## A simple iOS client that `GET`s unauthenticated or authenticated (OAuth) JSON data from and `POST`s authenticated data to a REST service.

Although it's easy enough to use `URLSession`s for unauthenticated calls and authenticated ones using a tool like [`OAuthSwift`](https://github.com/OAuthSwift/OAuthSwift/), this `JSONClient` simplifies those operations and serves as the base class of the clients in my [`SwiftDiscogs`](https://github.com/jrtibbetts/SwiftDiscogs/), [`SwiftMusicbrainz`](https://github.com/jrtibbetts/SwiftMusicbrainz/), and [`SwiftGenius`](https://github.com/jrtibbetts/SwiftGenius/) clients.

See the [Example](./Example.md) page for usage instructions.
