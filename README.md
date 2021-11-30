[![Generic badge](https://img.shields.io/badge/Language-Swift-red.svg)](https://developer.apple.com/swift/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
 
## *Countries App*


## Table of Contents
- <a href="#description">Description</a>
- <a href="#tech-stack">Tech Stack</a>
- <a href="#libraries">Libraries</a>
- <a href="#implementation-and-features">Implementation and Features</a>
- <a href="#requirements">Requirements</a>
- <a href="#previews-for-usage">Previews for Usage</a>
- <a href="#license">License</a>

## Description

Countries App an iOS app created by using GeoDB Cities API. Users may browse through a list of countries, add a country to their own save list and vice versa, and go through the detail information of the selected country.

## Tech Stack

* RxSwift
* MVVM, reactive patterns for bindings 
* Swift Package Manager 
* Storyboard approach for UI design; support only portrait mode for various devices.
* CoreData, for saving country codes
* Separate networking layer by protocol extensions
* Unit testing *(just for an example implementation)* 
* Some reusable views, custom alerts, activity indicators, organized folder structure.


## Libraries

* RxSwift https://github.com/ReactiveX/RxSwift
* SVGKit  https://github.com/SVGKit/SVGKit

## Implementation and Features

We have 3 layers in this project: 
  * *Data layer(repository):* consist of the api logics for "Main" and "Saved" screens. It is the only source of truth for the country list. It contains both fetched and persisted data. 
  * *ViewModel layer:* consists of only business logics for each seperated screens and it communicates with data layer and conduct the information to the view layer like MVVM suggested. That layer serves as an intermediator between data and view layers.
  * *View layer:* consists of view controllers and storyboards, and doesn't include any business logic like MVVM suggested.
    

## Requirements

* Xcode 13.1
* Swift 5.5
* iOS 15.0 deployment target
* Only portrait mode


## Previews for Usage 
| Preview |  
| --- | 
| ![Preview](gifs/preview.gif) | 


## License
```
Copyright (c) 2021 Gizem Boskan

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
