# Event Finder

An interview project for Sysco LABS. An iOS app that lets you find events using the Seat Geek API. The type ahead updates a list of results as the search query changes. Results can be tapped to view them on a details screen and added as a favorite for later.

**Note:** Dark mode support for iOS 13 is added in a separate branch called `dark_mode`. It is not merged with `master` yet because it will require using Xcode 11.

### Requirements

* iOS 11.0+
* Xcode 10.3
* Swift 5.0


### Installing

Clone the GIT repository:

```
git clone git@github.com:chesstep/EventFinder.git
```

After the repository is cloned you should run `pod update` from the local directory. This will download the necessary dependencies and generate `EventFinder.xcworkspace`

### Running the project

Open the `EventFinder.xcworkspace` in Xcode and select `Build and Run`

### Attribution

`EventFinder` uses the following third-party frameworks:

| Framework | Description |
|---|---|
| [Kingfisher](https://github.com/onevcat/Kingfisher) | Download and cache images from the web |
