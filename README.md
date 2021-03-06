# FeedCollectionViewController

[![Build Status](https://travis-ci.org/oliveroneill/FeedCollectionViewController.svg?branch=master)](https://travis-ci.org/oliveroneill/FeedCollectionViewController)
[![Version](https://img.shields.io/cocoapods/v/FeedCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FeedCollectionViewController)
[![License](https://img.shields.io/cocoapods/l/FeedCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FeedCollectionViewController)
[![Platform](https://img.shields.io/cocoapods/p/FeedCollectionViewController.svg?style=flat)](http://cocoapods.org/pods/FeedCollectionViewController)

A simple framework for creating data feeds so that data can be loaded
dynamically as the user scrolls. This is inspired by scrolling through photos
on Facebook or Instagram.

![Refresh Content by swiping down](Images/refresh.gif)    ![Images load as you scroll](Images/loads_as_scroll.gif)     ![Load bulk content when the user reaches the bottom of the feed](Images/infinite_scroll.gif)    ![Scroll through photos one at a time by tapping them](Images/view_photos.gif)

<sup>Images taken from the example project that uses colours in place of real content.</sup>

FeedCollectionViewController is a generic framework for setting up a simple
feed, whereas ImageFeedCollectionViewController is specifically set up for
images. ImageFeedCollectionViewController uses a [fork](https://github.com/oliveroneill/OOPhotoBrowser)
of [IDMPhotoBrowser](https://github.com/ideaismobile/IDMPhotoBrowser),
so that tapping on images lets you scroll through photos indefinitely.

## Migrating to version 2
With version 2, the framework uses a delegate architecture to separate the
concerns of error cases, data sources and UI events. This requires:
- Implementing protocols as needed
- Setting the properties on the controller
The example project has been updated to reflect this. For a simple use case,
you can just implement the `ImageFeedDataSource` protocol and then call:
```swift
    imageFeedSource = self
```
inside `viewDidLoad` or wherever appropriate, on your sublcassed
`ImageFeedCollectionViewController`. The [Usage](#usage) section below
goes into detail of using this framework, as well as where each method
has been moved to.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
The example project demonstrates the functionality without using any actual content, it creates
coloured images to illustrate its use with a large amount of content.

## Installation

FeedCollectionViewController is available through [CocoaPods](http://cocoapods.org). To install
FeedCollectionViewController, simply add the following line to your Podfile:

```ruby
pod "FeedCollectionViewController"
```

To install ImageFeedCollectionViewController, simply add the following line to
your Podfile:

```ruby
pod "ImageFeedCollectionViewController"
```

## Usage

The set up is quite similar to `UICollectionViewController`, you must specify a
reuse identifier and a `UICollectionViewCell` that should take its data from a
`CellData` implementation.

FeedCollectionViewController:

``` swift
open class ExampleImplementation: FeedCollectionViewController, FeedDataSource {

    override open func viewDidLoad() {
        super.viewDidLoad()
        feedDataSource = self
    }

    open func getReuseIdentifier(cell:CellData) -> String {
        // specifies the identifier of the cell, this can differ per cell
    }

    open func getCells(start:Int, callback: @escaping (([CellData]) -> Void)) {
        // get new cell data, this does not actually mean the cell is being shown
        // call `callback` with the new data. `start` is the query starting position
    }

    open func loadCell(cellView: UICollectionViewCell, cell:CellData) {
        // load the cell since it's now actually shown
    }
```

ImageFeedCollectionViewController:

``` swift
open class ExampleImplementation: ImageFeedCollectionViewController, ImageFeedDataSource {

    override open func viewDidLoad() {
        super.viewDidLoad()
        imageFeedSource = self
    }

    open func getImageReuseIdentifier(cell: ImageCellData) -> String {
        // specifies the identifier of the cell, this can differ per cell
    }

    open func getImageCells(start:Int, callback: @escaping (([ImageCellData]) -> Void)) {
        // get new cell data, this does not actually mean the cell is being shown
        // call `callback` with the new data. `start` is the query starting position
    }

    open func loadImageCell(cellView: UICollectionViewCell, cell:ImageCellData) {
        // load the cell (ie. a thumbnail) since it's now actually shown
    }
```

You must have a custom `ImageCellData` implementation, this subclasses
`IDMPhoto`, which will be used in the photo browser. To use with image
URLs use `super.init(url: imageUrl)` within `ImageCellData`.

To customise views in the ImageFeedCollectionViewController, you can
implement `SingleImageView` and set the `imageFeedPresenter` property.
The relevant methods are the same as those in `IDMCaptionView`.
``` swift
    open override func setupCaption() {
        // Setup caption views
    }

    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        // Return the height of the view, the width will be ignored
    }
```
To receive updates when the displayed photo changes, set the `browserDelegate`
property. This will also give you callbacks on image failures and allow toolbar
modifications.

Custom error messages and views are also available for feed retrieval failure
through the `errorDataSource` property or the `errorPresenter` property for
greater control of the views.

## Testing
Testing is done through FBSnapshotTestCase, there are test result files included
in `Example/Tests/ReferenceImages_64/FeedCollectionViewController_Tests.Tests`.
These were run with iPhone SE Simulator, however you can re-run on your own
device by enabling `recordMode` in `setUp()` and then re-running the test with
it off.

## Todo
- Allow properties to be accessed via IBOutlets. This looks a little complicated
with the current setup, due to having default implementations for
`FeedDataSource`. Looks like I need to move everything into classes or remove
default for `getCellsPerRow`. See [this](https://stackoverflow.com/a/39604189)
for more info.
- Better tests. Currently I've only implemented snapshot tests
- The snapshot tests are based on timers where something like
[EarlGrey](https://github.com/google/EarlGrey) would be better suited but I
had trouble with timeout errors when attempting this
- `ImageCellData` inherits from `IDMPhoto` which makes the cell data tied to
view code, when it's preferable for it to be a "dumb" model, usually a struct.

## Author

Oliver O'Neill

## License

FeedCollectionViewController is available under the MIT license. See the LICENSE file for more info.
