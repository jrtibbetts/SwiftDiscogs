# Stylobate
[![Build Status](https://travis-ci.org/jrtibbetts/Stylobate.svg?branch=master)](https://travis-ci.org/jrtibbetts/Stylobate)
![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/jrtibbetts/Stylobate/branch/master/graph/badge.svg)](https://codecov.io/gh/jrtibbetts/Stylobate)
[![codebeat badge](https://codebeat.co/badges/8fefc4d3-57f2-42c4-b19f-25de39c39564)](https://codebeat.co/projects/github-com-jrtibbetts-stylobate-master)
[![Maintainability](https://api.codeclimate.com/v1/badges/00de94524667de08f2fe/maintainability)](https://codeclimate.com/github/jrtibbetts/Stylobate/maintainability)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

A handy library of common UI components that I use in my various projects. They may or may not be of any use to you. Highlights include:

 * [`BusyView`](./Stylobate/BusyView.swift), a protocol that can be implemented by [`UIView`](https://developer.apple.com/documentation/uikit/uiview)s to display a [`UIActivityIndicatorView`](https://developer.apple.com/documentation/uikit/uiactivityindicatorview) or [`UIProgressView`](https://developer.apple.com/documentation/uikit/uiprogressview) over its other subviews to indicate that some action is being taken in the background
 * [`Controller`](./Stylobate/Controller.swift), a protocol for [`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller)s that have a [`Display`](./Stylobate/Display.swift) and [`Model`](./Stylobate/Model.swift) to offload UI and data model responsibilities that are normally in a view controller.
 * [`UIViewController+Alerts`](./Stylobate/UIViewController+Alerts.swift), a protocol that [`UIViewController`](https://developer.apple.com/documentation/uikit/uiviewcontroller)s can implement to present alert controllers in a standard way.
