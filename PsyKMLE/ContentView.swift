//  ContentView.swift
//  DrLicesingExamPsy
//
//  Created by NohJaisung on 11/17/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // 앱 이름과 버전은 런치스크린(LaunchScreen.storyboard)이 보여주므로
    // 같은 내용을 반복하는 시작화면 없이 바로 문항 목록으로 들어간다.
    var body: some View {
        MainAppView()
    }
}

private struct MainAppView: View {
    var body: some View {
        let endDate = endDateReturn(year: 2050, month: 12, day: 1)

        if Date() < endDate {
            QuestionView()
        } else {
            EndView()
        }
    }
}

func endDateReturn(year: Int, month: Int, day: Int) -> Date {
    let myDateComponents = DateComponents(year: year, month: month, day: day)
    if let date = Calendar.current.date(from: myDateComponents) {
        return date
    } else {
        return Date()
    }
}

#Preview {
    ContentView()
}
