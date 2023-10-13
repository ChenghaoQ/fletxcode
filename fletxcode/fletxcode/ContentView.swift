//
//  ContentView.swift
//  fletxcode
//
//  Created by Chenghao Qian on 10/13/23.
//
import SwiftUI
import Foundation //for sleep



func find_exec_in_bundle(nameFile:String?,pathDir:String?,fileType:String?) -> String? {
    // 获取应用程序的主 bundle
    let mainBundle = Bundle.main
    // 获取项目目录下的 core 文件的路径
    if let coreFolderPath = mainBundle.path(forResource: nameFile, ofType: fileType, inDirectory: pathDir) {
        return coreFolderPath
    } else {
        return nil
    }
}

func validateBookmarkData() -> Bool {
    // 从 UserDefaults 中检索书签数据
    if let bookmarkData = UserDefaults.standard.data(forKey: "securityScopedBookmark") {
        do {
            // 尝试还原书签数据为 URL
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData, options: .withSecurityScope, bookmarkDataIsStale: &isStale)
            // 检查书签数据是否过期
            if isStale {
                print("Bookmark data is stale.")
                return false
            }
            
            // 使用 URL 访问资源
            if FileManager.default.fileExists(atPath: url.path) {
                print("Bookmark data is valid.")
                // 在这里可以使用 URL 访问资源
                return true
            } else {
                print("Resource does not exist at path: \(url.path)")
                return false
            }
        } catch {
            print("Error resolving bookmark data: \(error)")
            return false
        }
    } else {
        print("Bookmark data not found in UserDefaults.")
        return false
    }
}


struct ContentView: View {
    var body: some View {
        EmptyView()
            .onAppear {
                NSApp.setActivationPolicy(.accessory) // 设置无窗口
                let _ = validateBookmarkData()
                let executable = "fletxcode_app"
                let exec_dir = "fletxcode_app_dir"
                if let resourceFolderURL = Bundle.main.url(forResource: exec_dir, withExtension: nil) {
                    do {
                        let bookmarkData = try resourceFolderURL.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                        UserDefaults.standard.set(bookmarkData, forKey: "securityScopedBookmark")
                        if resourceFolderURL.startAccessingSecurityScopedResource() {
                            print("Accessing Bundle Resources.")
                            // 在这里可以访问资源文件夹/
                            // 请确保在使用完后调用 stopAccessingSecurityScopedResource()
                            if let exec_path = find_exec_in_bundle(nameFile: executable, pathDir: exec_dir,fileType: nil){
                                print("Find \(exec_path)")
                                
                                let runner = ExternalProcessRunner(
                                    executableURL: URL(fileURLWithPath: exec_path),
                                    currentDirectoryPath: nil,
                                    arguments: [""],
                                    environments: [//add system environment to flet app
                                        "BUNDLE_PATH":Bundle.main.bundlePath,
                                        "FLETAPP_BUNDLE_PATH":"/\(exec_dir)/_internal/flet/bin",
                                        "FLETD_BUNDLE_PATH":"/\(exec_dir)/_internal/flet/bin"
                                    ]
                                )
                                runner.runProcess()
                            }
                            else{
                                print("Cannot Find executive file")
                            }
                            
                            resourceFolderURL.stopAccessingSecurityScopedResource()
                            
                        } else {
                            // 获取权限失败的处理
                            print("Failed to start accessing security scoped resource.")
                        }
                    } catch {
                        // 捕获其他可能的异常
                        print("Error creating bookmark data: \(error)")
                    }
                }

                //sleep(3) // 阻塞：休眠20秒
                exit(0)   // 退出程序
            }
        }
}


