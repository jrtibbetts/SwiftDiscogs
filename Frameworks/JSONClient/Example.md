#  Using `JSONClient`

## 1. Installation

`JSONClient` is currently installable via [Carthage](https://github.com/Carthage/Carthage) and by downloading the project manually. (CocoaPods and Swift Package Manager support are coming soon.)

### Carthage

 1. Create an empty text file called `Cartfile` at the root folder of your project. Copy the following line into it:
```
github "jrtibbetts/JSONClient"
```
 If you want to use only a specific version, you can do so with the following line instead:
```
github "jrtibbetts/JSONClient" ~> 0.5.0
```
 2. Open a Terminal window at the root folder of your project and run the following command:
```
carthage update --platform iOS
```
 This will check out the latest (or, if you specified a version, that version of the) code and compile it. When the build finishes, you'll see a new file (`Cartfile.resolved`) and folder (`Carthage`) in the folder from which you ran Carthage. `Cartfile.resolved`  will look exactly like your `Cartfile`, except that every dependency will have a specific version number next to it. (You should check both the `Cartfile` and `Cartfile.resolved` into your project's change management system.)

 The `Carthage` folder has two subfolders: `Build` and `Checkouts`.  You'll use the `Build` folder's location in the next step.

## 2. Integration

### In an app target
 1. To include `JSONClient` in an app target, select the target in the **projects and targets list**.
 2. Select the **General** tab.
 2. In the **Embedded Binaries** section, drag the `JSONClient.framework` file from the `Build` folder into the list, or click the **+**, navigate to the  `Build` folder (it won't appear in the initial list) and select `JSONClient.framework`.

### In a test target
 1. Select the test target in the **projects and targets list**.
 2. Select the **Build Phases** tab.
 3. In the **Link Binary With Libraries** section, add `JSONClient.framework` the same was as in step 3 of adding it to an app target.

## 3. Using the `JSONClient` directly

 1. If necessary, create `Codable`  `class`es and/or `struct`s for each data type that can be returned by the API's JSON responses. Add a property for each of the top-level JSON keys that can be returned. **Important:** all non-`Optional` properties *must* be found in the JSON response, or else the parsing will fail. If you're not sure whether a property will always exist in the response, make it `Optional`.
```
struct UserInfo: Codable {
    var name: String
    var id: Int
    var thumbnail: URL?
}
```
 2. If the JSON response contains subelements, create `Codable` `class`es and/or `struct`s for those, too.
```
struct Avatar: Codable {
    var image: URL
    var width: Int
    var height: Int
    var caption: String?
}
```
 3. Add the following line to the top of your source file:
```
import JSONClient
```
 4. Initialize the `JSONClient` with an optional base URL against which all subsequent `get()` paths will be resolved.
```
var client = JSONClient(baseUrl: URL("https://myawesomeapi.com")
```
 5. Call `get()` for the desired path. Pass in HTTP request headers (a `Dictionary` of `String: String`) and/or query parameters (an `Array` of `URLQueryItem`s, each of which has a `String` key and `Any` value), if needed. The return value is a `Promise` of a `Codable` type that matches the format of the JSON retrieved by `get()`. **It is critically important to specify the `Promise`'s type.**
```
var promise: Promise<UserInfo> = client.get(path: "userInfo")
```
or
```
var promise: Promise<UserInfo> = client.get(path: "userInfo", headers: ["User-Agent": "My App's User-Agent Identifier"])
```
or
```
var promise: Promise<UserInfo> = client.get(path: "userInfo",
                                            headers: ["User-Agent": "My App's User-Agent Identifier"],
                                            parameters: [URLQueryItem(name: "username", value: "Charlemagne"])
```
 4. The returned `Promise`  is processed by calling its `then` function (if successful) and `catch` *function* (if not).
```
promise.then { (userInfo) -> Void in
    print("Username: \(userInfo.name)")
}.catch { (error)
    // handle the error. It's usually a `JSONClient.JSONErr` enumeration value.
}
```

