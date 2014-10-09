hacktoolkit-ios_lib (Hacktoolkit for iOS)
=========================================

This library project has many useful wrappers, data structures, and reusable components for iOS programming.

Currently, CocoaPods does not support Swift source files. To use, add this project as a submodule.

* `git submodule add git@github.com:hacktoolkit/hacktoolkit-ios_lib.git htk`
* Import the `htk/Hacktoolkit` directory into Xcode.
  * `Add Files to "YOURPROJECT"...`
  * Navigate to and select `htk/Hacktoolkit`
  * Select `Create groups` for added folders radio
* After the initial setup, future updates can be done like so:
  * `cd htk`
  * `git pull`
  * `git submodule update --init` (`--init` can be left off after the initial update)

## Requirements

* N/A

## Sample Projects using Hacktoolkit for iOS

* [Pkkup](https://github.com/pkkup/Pkkup-iOS)
* [Twitter Client](https://github.com/hacktoolkit/htk-ios-Twitter)
* [Yelp Client](https://github.com/hacktoolkit/htk-ios-Yelp)
* [Rotten Tomatoes Client](https://github.com/hacktoolkit/htk-ios-RottenTomatoes)
* [Tip Calculator](https://github.com/hacktoolkit/htk-ios-TipCalculator)

## License

* For `hacktoolkit-ios_lib` see `LICENSE`
* The Font Awesome font is licensed under the SIL OFL 1.1:
  * <http://scripts.sil.org/OFL>
* Font Awesome by Dave Gandy - <http://fontawesome.io>
  * Full details: <http://fontawesome.io/license>
