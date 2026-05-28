import SwiftUI

struct WelcomeView: View {
    @AppStorage("welcomeShownForVersion") private var welcomeShownForVersion = ""
    @State private var showStartButton = false

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

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

                Text("2026.7월 예정 의사국가고시 정신의학 대비")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Text("Version \(appVersion)")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))

                Spacer()
            }
            .padding()
        }
        .safeAreaInset(edge: .bottom) {
            Button("시작하기") {
                welcomeShownForVersion = appVersion
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
            .opacity(showStartButton ? 1 : 0)
            .offset(y: showStartButton ? 0 : 16)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                showStartButton = true
            }
        }
    }
}

#Preview {
    WelcomeView()
}
