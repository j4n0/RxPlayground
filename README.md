A playground has access to external frameworks if it is part of a workspace that builds a target configured to access those frameworks.

If you want to add a playground to an existing carthage project, you only need to save the project as a workspace (File > Save as Workspace…), build the target, and you are done.

If you just want to distribute a playground with third party frameworks, you need to create a dummy workspace. Here is a step by step example for a playground with the [RxSwift][1] framework:

 1. **Create a new Xcode project** of type Cross-platform > Other > Empty. Name it RxPlayground. <br/>This will create this structure RxPlayground/RxPlayground.xcodeproj and open a blank Xcode.

 2. **Download RxSwift** with Carthage
 - Create a Cartfile with this line: `github "ReactiveX/RxSwift" "swift4.0"`
 - Run Carthage with `carthage update --platform iOS`. 

 2. **Add a playground** to the project.
 - Click File > New > Playground…
 - Choose the iOS > Blank template and name it Rx.playground
 - Right click the project node and choose “Add Files to RxPlayground”.
 - Select the Rx.playground and add it.

 5. **Create a workspace**
 - Click File > Save as Workspace…
 - Save as Rx.xcworkspace

 6. **Copy the frameworks** to the products directory.
 - Close the project and open the Rx.xcworkspace
 - Create a Cross-platform > Other > Aggregate. Name it RxAggregate
 - Create a New Run Script Phase with the following content:
<pre>
    cp -rv "${SRCROOT}/Carthage/Build/iOS/" "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
</pre>

At this point, Xcode and the Finder look like this:

[![xcode][2]][2]

Note that Carthage/ and Cartfile.resolved appear when you run Carthage, Without them, your playground will be only a few Ks.

[![Finder][3]][3]

Lastly, build the project (⌘B). Now you can use the framework in your playground:

    //: Playground - noun: a place where people can play
    import RxSwift
    
    _ = Observable<Void>.empty()
        .subscribe(onCompleted: {
            print("Completed")
        })

  [1]: https://github.com/ReactiveX/RxSwift
  [2]: https://i.stack.imgur.com/baCr1.png
  [3]: https://i.stack.imgur.com/Ic0bV.png
