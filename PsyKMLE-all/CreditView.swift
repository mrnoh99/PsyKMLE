
import SwiftUI

struct CreditView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                
                Spacer()
                Button("닫기") {
                   dismiss()
                }.padding()
             .springLoadingBehavior(.enabled) }
            Text("프로그램 작성 및 내용 감수: 노재성 \n아주대학교 의과대학 정신과학교실 교수 \n jsnoh2010@me.com"
            )
                .font(.headline)
                .padding()
        }
        //   .containerRelativeFrame(.vertical, count: 2, spacing: 10.0)
        
    }
}




