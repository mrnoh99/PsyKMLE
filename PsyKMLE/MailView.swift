import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    @State var messageBodyForFile : String
    let recipients = ["jsnoh2010@gmail.com"]
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        let nowDate = Date.now
     let chinaLocale = Locale(identifier: "zh_CN")
        let text = nowDate.formatted(.dateTime.locale(chinaLocale).second().minute().hour().day().month().year())
        let messageBody = "<앱을 만든이에게 Memo내용을 제출 합니다> \n 아주의대 학생은 학번과 이름을  적어 주세요 \n 학번:\n      이름:               \n\(text)"
        vc.mailComposeDelegate = context.coordinator
        vc.setMessageBody(messageBody, isHTML: false)
        vc.setToRecipients(recipients)
        vc.setSubject("Psy KMA memo")
        
        if let data = (messageBodyForFile as NSString).data(using: NSUTF8StringEncoding ){
            //Attach File
            vc.addAttachmentData(data, mimeType: "text/plain", fileName: "memo.csv")
         
        }
        
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
