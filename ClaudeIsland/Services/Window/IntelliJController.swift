//
//  IntelliJController.swift
//  ClaudeIsland
//
//  Focuses IntelliJ IDEA project windows using the JetBrains CLI
//

import Foundation
import os.log

/// Controller for IntelliJ IDEA window focus via CLI
final class IntelliJController: Sendable {
    static let shared = IntelliJController()
    private static let logger = Logger(subsystem: "com.claudeisland", category: "IntelliJController")

    /// The found IDE path (computed once at init)
    let ideaPath: String?

    /// Whether IntelliJ CLI is available
    let isAvailable: Bool

    private static func debugLog(_ message: String) {
        let logFile = NSHomeDirectory() + "/claude-island-debug.log"
        let line = "\(Date()): \(message)\n"
        if let data = line.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFile) {
                if let handle = FileHandle(forWritingAtPath: logFile) {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    handle.closeFile()
                }
            } else {
                FileManager.default.createFile(atPath: logFile, contents: data)
            }
        }
    }

    private init() {
        let paths = [
            "/usr/local/bin/idea",
            "/Applications/IntelliJ IDEA CE.app/Contents/MacOS/idea",
            "/Applications/IntelliJ IDEA.app/Contents/MacOS/idea",
        ]
        var foundPath: String?
        for path in paths {
            let exists = FileManager.default.fileExists(atPath: path)
            let executable = FileManager.default.isExecutableFile(atPath: path)
            Self.debugLog("checking \(path): exists=\(exists) executable=\(executable)")
            if executable {
                foundPath = path
                break
            }
        }
        self.ideaPath = foundPath
        self.isAvailable = foundPath != nil
        Self.debugLog("isAvailable=\(self.isAvailable) path=\(self.ideaPath ?? "none")")
    }

    /// Focus the IntelliJ project window matching the given working directory
    func focusProject(cwd: String) async -> Bool {
        guard let path = ideaPath else { return false }

        let result = await ProcessExecutor.shared.runWithResult(path, arguments: [cwd])
        switch result {
        case .success:
            return true
        case .failure:
            return false
        }
    }
}
