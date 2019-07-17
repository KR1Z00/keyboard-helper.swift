# Swift Helpers!

This repository is a collection of various swift helpers.
Helpers are classes that are inherited to provide added functionality with ease.
Below is a list of the current helpers in the repository along with instructions on how to implement them.

## Keyboard Handling View Controller

This class is a View Controller that already has all the functionality needed to handle keyboard related events.
It handles things such as:

- Hiding the keyboard when the user taps the return key
- Hiding the keyboard if the user taps outside of the textfield
- Moving the view upwards if the keyboard will hide the selected textfield

**How to implement this helper**

Using this helper is very simple.

1. Copy and paste the _KeyboardHandlingViewController.swift_ file into your project directory
2. Create a new class for your view controller and make it inherit the _KeyboardHandlingViewController_ class as such:

```
class MyViewController: KeyboardHandlingViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
```

You're good to go!
