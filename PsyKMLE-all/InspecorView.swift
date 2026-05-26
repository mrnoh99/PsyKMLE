import SwiftUI
import MessageUI

struct InspectorView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var presentInspector: Bool

    @State private var presentCompositMemo: Bool = false
    @State private var result: Result<MFMailComposeResult, Error>? = nil
    @State private var isShowingMailView = false

    let allQuestions: [Question]

    private var compositMemo: String {
        Self.allMemoString(allQuestions: allQuestions)
    }

    var body: some View {
        VStack(spacing: 0) {
            headerView

            VStack(spacing: 16) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        introSection
                        solveSection
                        filterSection
                        iconSection
                        answerSection
                        saveSection
                    }
                    .padding()
                }
                .scrollIndicators(.hidden)
                .textSelection(.disabled)
                .background(.background.secondary, in: RoundedRectangle(cornerRadius: 20))

                footerView
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

// MARK: - Sections
private extension InspectorView {
    var headerView: some View {
        HStack {
            Spacer()

            Text("사용설명")
                .font(.headline)
                .bold()
                .padding()

            Spacer()

            Button("닫기") {
                presentInspector = false
                dismiss()
            }
            .padding()
            .springLoadingBehavior(.enabled)
        }
    }

    var introSection: some View {
        Text("""
        이 앱은 2019년 이후 의사 국가 고시의 정신건강의학 기출 문제 학습 앱입니다.
        문제는 기출문제에 기초하여 출제의 기본 의도를 충실히 유지하도록 출제하였으며, 기출문제를 학습하는 것과 동일한 내용을 학습할 수 있도록 구성하였습니다.
        """)
        .inspectorBodyStyle()
    }

    var solveSection: some View {
        Group {
            Text("문제 풀기 및 답안확인")
                .inspectorTitleStyle()

            HStack(alignment: .firstTextBaseline, spacing: 0) {
                Text("[ 문제풀기 ]와 [ 답안보기 ] 중 한가지를 선택합니다. [ 문제풀기 ]와 [ 답안보기 ]는 한 문제씩 풀 수도 있고 모아서 풀 수도 있습니다. 문제 문항별로 풀거나 답을 확인하려면 문제리스트의 원하는 문항을 터치하여 선택하면 됩니다. 필터한 문항리스트를 모아서 풀거나 답안을 확인하려면 [")
                Image(systemName: "play.square")
                Text("] 버튼을 선택하면 됩니다.")
            }
            .inspectorBodyStyle()
        }
    }

    var filterSection: some View {
        Group {
            Text("문항 필터링")
                .inspectorTitleStyle()

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("1. 별표 아이콘 ([")
                    Image(systemName: "star")
                    Text("])은 별표로 표시한 문항을 필터합니다. 각 문항의 별표를 터치하면 별표시가 토글되어 ([")
                    Image(systemName: "star.fill")
                    Text("]) 상태로 바뀝니다.")
                }

                Text("첫 화면인 문제 리스트 화면과 답안확인 화면에서 별표는 토글할 수 있습니다.")

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("2. 메모 아이콘 ([")
                    Image(systemName: "note.text.badge.plus")
                    Text("])은 각 문항 중 메모에 내용이 있는 문항을 필터합니다. 메모는 사용자가 원하는 내용을 저장하며 현재는 텍스트만 저장됩니다. 메모 항목에 내용이 있는 문항은 ([")
                    Image(systemName: "checkmark")
                    Text("])로 아이콘이 바뀝니다.")
                }

                Text("3. 메모는 문제리스트 화면과 답안확인 화면에서 확인 및 작성이 가능합니다.")

                Text("4. 키워드를 사용한 필터가 가능하며, 키워드는 입력하기 시작하면 현재 키워드에 포함된 항목의 선택리스트가 제시됩니다. 영문 키워드는 저장 시 소문자로 변환됩니다. 키워드는 사용자가 각 문항별로 추가하거나 삭제할 수 있습니다.")
            }
            .inspectorBodyStyle()
        }
    }

    var iconSection: some View {
        Group {
            Text("문항리스트 각 문항의 아이콘")
                .inspectorTitleStyle()

            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("문항리스트 각 문항의 앞부분의 아이콘 [ ")
                    Image(systemName: "questionmark.circle.fill")
                    Text(" ")
                    Image(systemName: "checkmark.circle.fill")
                    Text(" ")
                    Image(systemName: "xmark.circle.fill")
                    Text(" ]은 각각 풀지 않음, 정답, 오답을 표시합니다.")
                }

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("이는 [ 문제별 ] 픽업리스트의 항목 분류와 연결됩니다. 아직 풀지 않은 문제는 [ ")
                    Image(systemName: "questionmark.circle.fill")
                    Text(" ]으로 표시되며, 처음 프로그램을 설치하면 모든 문제가 이 상태로 표시됩니다.")
                }

                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("문제를 풀면서 답을 선택하지 않고 [ 제출 ]을 선택한 경우에도 [ ")
                    Image(systemName: "questionmark.circle.fill")
                    Text(" ]으로 표시됩니다. 풀지 않은 문제는 정답률과 오답률을 계산할 때 오답으로 계산합니다.")
                }
            }
            .inspectorBodyStyle()
        }
    }

    var answerSection: some View {
        Group {
            Text("답가지는 중복선택이 가능합니다.")
                .inspectorTitleStyle()

            Text("선택한 답가지를 취소하려면 다시 터치합니다. 제출한 선택은 취소할 수 없습니다.")
                .inspectorBodyStyle()
        }
    }

    var saveSection: some View {
        Group {
            Text("제출한 답, 메모, 키워드는 저장됩니다.")
                .inspectorTitleStyle()

            Text("""
            데이터는 사용자의 장치에 저장됩니다. 프로그램을 종료한 후 다시 시작하여도 그 동안 작성해 제출한 답, 메모, 키워드는 리셋되지 않습니다. 리셋을 원하면 프로그램을 데이터를 포함하여 삭제한 뒤 앱 스토어에서 다시 설치해야 합니다. 이런 경우 그 동안 입력한 데이터가 모두 삭제되고 제공자의 초기 데이터로 리셋된다는 점을 유의하십시오.
            """)
            .inspectorBodyStyle()
        }
    }

    var footerView: some View {
        HStack(alignment: .top, spacing: 8) {
            Spacer()

            Text("""
            프로그램 작성 및 문제 작성: 노재성
            아주대학교 의과대학 정신과학교실 교수
            jsnoh2010@gmail.com
            """)
            .font(.headline)
            .padding()

            Button {
                isShowingMailView.toggle()
            } label: {
                Image(systemName: "info.circle")
            }
            .padding(.top, 16)
            .sensoryFeedback(
                .impact(weight: .heavy, intensity: 0.9),
                trigger: presentCompositMemo
            )
            .springLoadingBehavior(.enabled)
            .disabled(!MFMailComposeViewController.canSendMail())
            .sheet(isPresented: $isShowingMailView) {
                MailView(
                    isShowing: $isShowingMailView,
                    result: $result,
                    messageBodyForFile: compositMemo
                )
            }
        }
    }
}

// MARK: - Helpers
private extension InspectorView {
    static func allMemoString(allQuestions: [Question]) -> String {
        var compositMemo = "No,Question,Memo\n"

        allQuestions.forEach { question in
            let intro = question.intro.replacingOccurrences(of: "\n", with: " ")
            let memo = question.memo.replacingOccurrences(of: "\n", with: " ")
            compositMemo += "\(question.id),\(intro),\(memo)\n"
        }

        return compositMemo
    }
}

private extension View {
    func inspectorBodyStyle() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
            .lineSpacing(8)
    }

    func inspectorTitleStyle() -> some View {
        self
            .bold()
            .padding(.top, 4)
            .padding(.bottom, 2)
    }
}
