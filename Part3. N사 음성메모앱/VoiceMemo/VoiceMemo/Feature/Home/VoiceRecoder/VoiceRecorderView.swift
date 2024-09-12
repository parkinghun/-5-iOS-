//
//  VoiceRecorderView.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import SwiftUI
import AVFoundation

struct VoiceRecorderView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()

    var body: some View {
        ZStack {
            VStack {
                TitleView()
                
                if voiceRecorderViewModel.recordedFiles.isEmpty {
                    AnnouncementView()
                } else {
                    VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
                        .padding(.top, 15)
                }
                
                Spacer()
            }
            
            RecordBtnView(voiceRecorderViewModel: voiceRecorderViewModel)
                .padding(EdgeInsets(top: 50, leading: 20, bottom: 50, trailing: 20))
        }
        .alert(
            "선택된 음성메모를 삭제하시겠습니까?",
            isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecoderAlert) {
                Button("삭제", role: .destructive) {
                    voiceRecorderViewModel.removeSelectedVoiceRecord()
                }
                
                Button("취소", role: .cancel) { }
            }
            .alert(voiceRecorderViewModel.alertMessage, isPresented: $voiceRecorderViewModel.isDisplayAlert) {
                Button("확인", role: .cancel) { }
            }
            .onChange(of: voiceRecorderViewModel.recordedFiles) { recordedFiles in
                homeViewModel.setVoiceRecoderCount(recordedFiles.count)
            }
    }
}


// MARK: - 타이틀 뷰
private struct TitleView: View {
    
    fileprivate var body: some View {
        HStack {
            Text("음성메모")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.customBlack)
            
            Spacer()
        }
        .padding(EdgeInsets(top: 30, leading: 30, bottom: 0, trailing: 30))
    }
}

// MARK: - 음성메모 안내 뷰
private struct AnnouncementView: View {
    fileprivate var body: some View {
        VStack(spacing: 15) {
            Rectangle()
                .fill(Color.ctmCoolGray)
                .frame(height: 1)
            
            Spacer()
                .frame(height: 180)
            
            Image("pencil")
                .renderingMode(.template)
            Text("현재 등록된 음성메모가 없습니다.")
            Text("하단의 녹음 버튼을 눌러 음성메모를 시작해주세요.")
            
            Spacer()
        }
        .font(.system(size: 16))
        .foregroundStyle(.customGray2)
    }
}

// MARK: - 음성메모 리스트 뷰
private struct VoiceRecorderListView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    
    fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
    }
    
    fileprivate var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .fill(Color.ctmGray2)
                    .frame(height: 1)
                
                ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
                    VoiceRecorderCellView(
                        voiceRecorderViewModel: voiceRecorderViewModel,
                        recordedFile: recordedFile
                    )
                }
            }
        }
    }
}

// MARK: - 음성메모 셀 뷰
private struct VoiceRecorderCellView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    private var recordedFile: URL
    private var creationDate: Date?
    private var duration: TimeInterval?
    
    private var progressBarValue: Float {
        if voiceRecorderViewModel.selectedRecordedFile == recordedFile
            && (voiceRecorderViewModel.isPlaying || voiceRecorderViewModel.isPaused) {
            return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
        } else {
            return 0
        }
    }
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        recordedFile: URL
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.recordedFile = recordedFile
        (self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)
    }
    
    fileprivate var body: some View {
        VStack {
            Button {
                voiceRecorderViewModel.voiceRecoderCellTapped(recordedFile)
            } label: {
                VStack {
                    HStack {
                        Text(recordedFile.lastPathComponent)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(.customBlack)
                        
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        if let creationDate {
                            Text(creationDate.formattedVoiceRecoderTime)
                                .font(.system(size: 14))
                                .foregroundStyle(.customIconGray)
                        }
                        
                        Spacer()
                        
                        if voiceRecorderViewModel.selectedRecordedFile != recordedFile,
                           let duration = duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 14))
                                .foregroundStyle(.customIconGray)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            
            if voiceRecorderViewModel.selectedRecordedFile == recordedFile {
                VStack {
                    ProgressBarView(progress: progressBarValue)
                        .frame(height: 2)
                    
                    Spacer()
                        .frame(height: 5)
                    
                    HStack {
                        Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(.customIconGray)
                        
                        Spacer()
                        
                        if let duration {
                            Text(duration.formattedTimeInterval)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundStyle(.customIconGray)
                        }
                    }
                    
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            if voiceRecorderViewModel.isPaused {
                                voiceRecorderViewModel.resumePlaying()
                            } else {
                                voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
                            }
                        } label : {
                            Image("play")
                                .renderingMode(.template)
                                .foregroundStyle(.customBlack)
                        }
                        
                        Spacer()
                            .frame(width: 10)
                        
                        Button {
                            if voiceRecorderViewModel.isPlaying {
                                voiceRecorderViewModel.pausePlaying()
                            }
                        } label: {
                            Image("pause")
                                .renderingMode(.template)
                                .foregroundStyle(.customBlack)
                        }
                        
                        Spacer()

                        Button {
                            voiceRecorderViewModel.removeBtnTapped()
                        } label: {
                            Image("trash")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.customBlack)
                        }
                    }
                }  // VStack
                .padding(.horizontal, 20)
            }  // if문
            
            Rectangle()
                .fill(.customGray2)
                .frame(height: 1)
        }
    }
}


// MARK: - 프로그레스 바
private struct ProgressBarView: View {
    private var progress: Float
    
    fileprivate init(progress: Float) {
        self.progress = progress
    }
    
    fileprivate var body: some View {
        GeometryReader { geometry in  // 기기의 사이즈를 판별하거나 읽을 수 있음
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.ctmGray2)
                
                Rectangle()
                    .fill(Color.ctmGreen)
                    .frame(width: CGFloat(max(0, min(1, self.progress))) * geometry.size.width)  // 값을 0과 1 사이로 제한
            }
            
        }
    }
}

// MARK: - 녹은 버튼 뷰
private struct RecordBtnView: View {
    @ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
    @State private var isAnimation: Bool
    
    fileprivate init(
        voiceRecorderViewModel: VoiceRecorderViewModel,
        isAnimation: Bool = false
    ) {
        self.voiceRecorderViewModel = voiceRecorderViewModel
        self.isAnimation = isAnimation
    }
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            HStack {
                Spacer()
                
                Button {
                    voiceRecorderViewModel.recorderBtnTapped()
                } label: {
                    if voiceRecorderViewModel.isRecording {
                        Image("mic_recording")
                            .scaleEffect(isAnimation ? 1.25 : 1.0)
                            .onAppear {
                                withAnimation(.spring().repeatForever()) {
                                    isAnimation.toggle()
                                }
                            }
                            .onDisappear {
                                isAnimation = false
                            }
                    } else {
                        Image("mic")
                    }
                }
            }
        }
    }
}


#Preview {
    VoiceRecorderView()
        .environmentObject(HomeViewModel())
}
