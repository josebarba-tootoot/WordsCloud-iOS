# Words cloud generator

A UIView subclass to generate a tags cloud

## Getting Started

Download the project, drag and drop WordsCloud.swift to your project.
Add a UIView in your Storyboard and make it class of WordsCloud.swift.
```swift
@IBOutlet weak var viewContainer: WordsCloud!
```

Call the constructor function
```swift
let words = ["Freedom", "God", "Happiness", "Imagination", "Intelligence", "Other"]

viewContainer.create(words: words, frame: wordsCloud.frame)
```

Assign the delegate
```swift
viewContainer.delegate = self
```

and implement it
```swift
func didTap(onWord word: String, index: Int) {
        // Do something
    }
```


## Authors

* **Jose Catala** - *Initial work* - https://github.com/josebarba-tootoot/WordsCloud-iOS


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

