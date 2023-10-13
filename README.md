
wrap a flet app in xcode
## 1. Preperation
temporarily replace flet_runtime/app.py with flet_runtime_app.py(All changes commented in flet_runtime_app.py markded with #!!!)
## 2. pack the sample
- in fletxcode.py py: 
  - app mode: use "ft.app(target=main)"
  - web browser mode: use "ft.app(target=main,view=ft.AppView.WEB_BROWSER)"
run : pyinstaller fletxcode.py
## 3.modify the packed app
app mode: go to dist/flexcode/_internal/flet/bin/,unzip the flet-macos-amd64.tar.gz at same folder

web browser mode: copy "flet/web" folder  to "dist/flexcode/_internal/flet"
## 4.open xcode project
drag the packed fletxcode folder to xcode project ,same level as fletxcodeApp.swift
## 5.change path of flexcode executable in ContentView.swift
in line 64-65:
```swift
      let executable = "fletxcode"//executable name, same level as _internal folder
      let exec_dir = "fletxcode" //folder name
```
## configure app sandbox
<img width="1136" alt="image" src="https://github.com/ChenghaoQ/fletxcode/assets/17086722/7f143f1e-c131-4e75-a30f-d2c0eba88718">


## 7.build and run in xcode
for the first, time, while the bookmark data not established,it might shows:

"Bookmark data not found in UserDefaults."
or 
"Failed to start accessing security scoped resource."

run and build again, it will show "Accessing Bundle Resources.", then the flet app will be successfully started.


