
//
//  AnswerView.swift
//  DrLicesingExamPsy
//
//  Created by NohJaisung on 11/17/23.
//

import SwiftUI
import Observation

struct StartListView: View {
    @State   var question: Question //변경 불가
    //  @State   var memoText: String
    @Binding var isStaredOn: Bool
    @State private var showPopoverMemo: Bool = false
    var sequenceOfProblem : Int
     
    
    // 행의 모든 요소를 세로 가운데에 맞춘다(iPad는 한 줄, iPhone은 왼쪽 칸을 세로로 쌓음).
    // 번호 자릿수(1~338)나 아이콘 모양이 달라도 열이 흔들리지 않도록 폭을 고정하며,
    // 글자 크기 설정(Dynamic Type)을 따라 함께 커진다.
    @ScaledMetric(relativeTo: .body) private var numberWidth: CGFloat = 34
    @ScaledMetric(relativeTo: .body) private var iconWidth: CGFloat = 26
    // iPhone 왼쪽 칸 폭. "2026-1"처럼 차수가 붙은 연도가 한 줄에 들어가야 한다.
    @ScaledMetric(relativeTo: .body) private var compactColumnWidth: CGFloat = 50
    // iPad처럼 넓은 화면(regular)에서는 행 위아래와 열 사이를 넓혀 여유 있게 보이게 한다.
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isRegularWidth: Bool { horizontalSizeClass == .regular }
    private var columnSpacing: CGFloat { isRegularWidth ? 14 : 8 }
    private var rowVerticalPadding: CGFloat { isRegularWidth ? 16 : 8 }

    var body: some View {
        Group {
            if isRegularWidth {
                // iPad: 번호·별표·결과·연도·문장·메모를 한 줄에 둔다.
                HStack(alignment: .center, spacing: columnSpacing) {
                    numberText
                        .frame(width: numberWidth, alignment: .trailing)
                    starIcon
                    statusIcon
                        .frame(width: iconWidth, height: iconWidth)
                    Text(question.year)
                        .monospacedDigit()
                        .fixedSize()
                    sentenceText
                    memoButton
                }
            } else {
                // iPhone: 폭이 좁아 한 줄에 모두 두면 문장이 예닐곱 줄로 쪼개진다.
                // 번호·별표·결과·연도를 왼쪽 한 칸에 세로로 쌓는다. 문항 번호(예: 260130)만으로는
                // 2026년 1차·2차를 구별할 수 없어 연도는 작은 글씨로 남긴다.
                HStack(alignment: .center, spacing: columnSpacing) {
                    VStack(spacing: 2) {
                        numberText
                        starIcon
                        statusIcon
                            .frame(width: iconWidth, height: iconWidth)
                        Text(question.year)
                            .font(.caption2)
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(width: compactColumnWidth)
                    sentenceText
                    memoButton
                }
            }
        }
        .padding(.vertical, rowVerticalPadding)
        // 구분선은 기본으로 행의 첫 글자에서 시작해 번호 자릿수마다 위치가 달라진다.
        // 모든 행에서 같은 곳(행의 앞 끝)에서 시작하게 고정한다.
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }

    private var numberText: some View {
        Text("\(sequenceOfProblem)")
            .monospacedDigit()
            .foregroundStyle(.secondary)
    }

    private var starIcon: some View {
        Image(systemName: question.stared == true ? "star.fill" : "star")
            .imageScale(.large)
            .foregroundStyle(.yellow)
            .frame(width: iconWidth, height: iconWidth)
            .contentShape(Rectangle())
            .onTapGesture {
                question.stared.toggle()
                if isStaredOn {
                    question.isOnSet.toggle()
                }
            }
    }

    // 문제 문장은 남는 폭을 모두 쓰고 가로·세로 가운데에 맞춘다.
    private var sentenceText: some View {
        Text("\(question.intro)  (\(question.id))")
            .textSelection(.disabled)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
    }

    private var memoButton: some View {
        let isMemoEmpty = question.memo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        return Button(action: {
            showPopoverMemo = true
        }, label: {
            Image(systemName: isMemoEmpty ? "note.text.badge.plus" : "checkmark")
                .frame(width: iconWidth, height: iconWidth)
        })
        .buttonStyle(.plain)
        .springLoadingBehavior(.enabled)
        .sensoryFeedback(
            .impact(weight: .heavy, intensity: 0.9), trigger: showPopoverMemo)
        .symbolEffect(.bounce, value: showPopoverMemo)
        .popover(isPresented: $showPopoverMemo) {
            MemoView(question: $question)
        }
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch ResultView.messageCorrectOrNot(question: question) {
        case "풀지않음":
            Image(systemName: "questionmark.circle.fill")
                .symbolRenderingMode(.multicolor)
        case "오답":
            Image(systemName: "xmark.circle.fill")
                .symbolRenderingMode(.multicolor)
        default:
            Image(systemName: "checkmark.circle.fill")
                .symbolRenderingMode(.multicolor)
        }
    }
}





