//
//  ScanView.swift
//  CantoSound
//
//  Created by Pak Lau on 25/9/2020.
//

import SwiftUI

struct ScanView: View {
    @Binding var capturedImage: UIImage
    @Binding var detectedSentences: [String]
    @Binding var keyword: String
    @Binding var showCameraView: Bool
    @Binding var selectedWord: ChineseWord
    @Binding var loadingDefinition: Bool
    
    var onCommitKeywordInputField: () -> Void
    
    func handleText(sentences: [String]) {
        print(sentences)
        detectedSentences = sentences
    }
    
    func handlePhotoReceived(image: UIImage?) {
        guard let image = image else {return}
        capturedImage = image
        
        let imageToTextProcessor = ImageToTextProcessor(textHandler: handleText)
        imageToTextProcessor.detect(image: image)
    }
    
    let cameraView = CameraView()
    var body: some View {
        VStack {
            cameraView
            Button(
                action : {
                    cameraView.controller.photoCaptureCompletionBlock = handlePhotoReceived
                    cameraView.controller.capturePhoto()
                    //                        showCameraView = false
                },
                label : {Image(systemName: "camera.viewfinder")
                    .resizable()
                    .foregroundColor(.white)
                    .frame( width:40, height: 40)
                })
            
            WordCandidateListView(words: $detectedSentences, selectedWord: $keyword, shouldViewPresented: $showCameraView, onWordSelected: onCommitKeywordInputField)
                .frame(minHeight: 300)
        }
    }
}