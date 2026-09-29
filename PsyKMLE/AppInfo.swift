import Foundation

/// 앱 번들에 기록된 버전 정보. 여러 화면에서 같은 표기를 쓰기 위해 한곳에 모았다.
enum AppInfo {
    /// CFBundleShortVersionString. Xcode의 타깃 설정에서 Version 항목.
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// CFBundleVersion. Xcode의 타깃 설정에서 Build 항목.
    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    /// "Version 3.0 (Build 9)" 형태. 값을 읽지 못하면 빈 문자열.
    static var versionLabel: String {
        guard !version.isEmpty else { return "" }
        guard !build.isEmpty else { return "Version \(version)" }
        return "Version \(version) (Build \(build))"
    }
}
