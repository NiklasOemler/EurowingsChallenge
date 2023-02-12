# Eurowings-Challenge
A simple iOS app i made for my job application at eurowings.
The goal was to show my code quality and skills in reactive programming, UIKit and SwiftUI with swift.

## Setup
* copy 'config-example.json' file with name 'config.json' into project root dir
* insert api configuration values

```
{
   "api":{
      "scheme":"https",
      "host":"jsonplaceholder.typicode.com"
   }
}
```

## Approach
This simple app is implemented without any use of third party libraries. The post listing uses UIKit and the post detail uses SwiftUI.

### Architecture
* i choosed the MVVM architecture because its best known for abstraction and seperation of view and business logic.
* the views subscribe and react to the observable viewstates of the viewmodel.
* data from the api gets fetched within view lifecycle hooks (viewDidAppear & onAppear)

### UI
* Due to the given time constraint, the ui is kept very simple.

### Tests
* Like the UI, the tests a are kept very simple cause of the given reason.
