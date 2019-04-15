[![Swift 4](https://img.shields.io/badge/Swift-4-orange.svg?style=flat)](https://swift.org)
[![Platforms macOS](https://img.shields.io/badge/Platforms-macOS%2010.10+-lightgray.svg?style=flat)](http://www.apple.com)
[![License MIT](https://img.shields.io/badge/License-MIT-lightgrey.svg?style=flat)](https://github.com/tadija/AEXML/blob/master/LICENSE)
[![Bitrise](https://app.bitrise.io/app/a580c2be91d2e578/status.svg?token=VXL1amG3aE9yGoqXSs1zbA&branch=develop)](https://bitrise.io)

# xibdump
MacOS command-line application for printing structure of .nib or .storyboardc files.
There is no any documentation about structure the .nib files. I received this information by reverse engineering, there is no guarantee that the data is fully accurate. At the time of creating, this project should reflect the state in macOS Mojave and iOS 12. It might however become obsolete with future macOS or iOS releases.

# Usage
```bash
Usage: xibdump <command> [options]

Command-line application for printing structure of .nib or .storyboardc files.

Commands:
  print           Print structure of compiled .nib file
  restore         Restore structure of compiled file (.nib -> .xib, .storyboardc - comming soon)
  help            Prints help information
  version         Prints the current version of this app
```
