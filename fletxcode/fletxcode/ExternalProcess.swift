//
//  ExternalProcess.swift
//  fletxcode
//
//  Created by Chenghao Qian on 9/30/23.
//


import Foundation

struct ExternalProcessRunner {
    let executableURL: URL
    let currentDirectoryPath: String?
    let arguments: [String]
    let environments:[String:String]?

    func runProcess() {
        let task = Process()
        task.executableURL = executableURL
        if let path = currentDirectoryPath{
            task.currentDirectoryPath = path
        }
        task.arguments = arguments
        
        if let envs = environments{
            var environment = ProcessInfo.processInfo.environment
            for (key, value) in envs {
                environment[key]=value
            }
            task.environment = environment
        }

        
        let outputPipe = Pipe()
        task.standardOutput = outputPipe

        do {
            try task.run()
            task.waitUntilExit()

            let data = outputPipe.fileHandleForReading.readDataToEndOfFile()
            if let outputString = String(data: data, encoding: .utf8) {
                print("进程输出(Process output)：")
                print(outputString)
            }
        } catch {
            print("Process Error:执行进程时出现错误：\(error)")
        }
    }
}

// Usage
//let runner = ExternalProcessRunner(
//    executableURL: URL(fileURLWithPath: "/path/to/your/executable"),
//    currentDirectoryPath: "/path/to/working/directory",
//    arguments: ["arg1", "arg2", "arg3"],
//    environments:['BUNDLE_PATH':Bundle.main.bundlePath]
//)
//runner.runProcess()

