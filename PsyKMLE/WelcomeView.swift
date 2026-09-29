import SwiftUI

struct WelcomeView: View {
    @AppStorage("welcomeShownForRelease") private var welcomeShownForRelease = ""

    /// 시작화면이 머무는 시간. 지나면 버튼 없이 저절로 문항 목록으로 넘어간다.
    private let displayDuration: Duration = .seconds(2)

    var body: some View {
        ZStack {
            Color(white: 0.333)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Text("PsyKMLE")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)

                Text("의사국가고시 정신의학 대비")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text(AppInfo.versionLabel)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()
            }
            .padding()
        }
        // 기다리지 않고 바로 넘어가고 싶을 때를 위해 화면 어디를 눌러도 진행한다.
        .contentShape(Rectangle())
        .onTapGesture(perform: proceed)
        .task {
            try? await Task.sleep(for: displayDuration)
            guard !Task.isCancelled else { return }
            proceed()
        }
    }

    private func proceed() {
        welcomeShownForRelease = AppInfo.releaseKey
    }
}

#Preview {
    WelcomeView()
}
