//
//  VoiceRecorderViewModel.swift
//  VoiceMemo
//
//  Created by 박성훈 on 7/8/24.
//

import AVFoundation

// NSObject 클래스를 채택한 이유 - AudioRecoderManager라는 서비스 객체를 만들면서,
// 해당 객체를 뷰에 얹어서 사용하기 위해 ObservableObject 채택
// 음성 메모의 재생 끝 지점 등 내장되어있는 메소드를 사용하기 위해 AVAudioPlayerDelegate 프로토콜을 채택
// AVAudioPlayerDelegate는 내부적으로 NSObject를 채택하고 있음
// CoreFoundation 속성을 가진 타입 -> 객체들이 실행되는 런타임 시에 런타임 메커니즘이 해당 프로토콜을 기반으로 동작하게 된다. -> NSObject를 상속받아서

// 음성 메모를 담당하는 서비스 객체
final class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate{
    // 알럿 관련 프로퍼티
    @Published var isDisplayRemoveVoiceRecoderAlert: Bool  // 삭제 알럿
    @Published var isDisplayAlert: Bool  // 에러 알럿
    @Published var alertMessage: String
    
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool  // 녹음중
    
    /// 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool  // 재생중
    @Published var isPaused: Bool  // 재생 중지?
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
    /// 음성메모된 파일(데이터)
    var recordedFiles: [URL]
    
    /// 현재 선택된 음성메모 파일
    @Published var selectedRecordedFile: URL?
    
    init(
        isDisplayRemoveVoiceRecoderAlert: Bool = false,
        isDisplayErrorAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool = false,
        isPaused: Bool = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecordedFile: URL? = nil
    ) {
        self.isDisplayRemoveVoiceRecoderAlert = isDisplayRemoveVoiceRecoderAlert
        self.isDisplayAlert = isDisplayErrorAlert
        self.alertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecordedFile = selectedRecordedFile
    }
}


// MARK: - 뷰 관련 메서드(상태, 유저 인터액션)
// 셀 클릭시, 삭제버튼 클릭 시, 알럿 관련 메서드
extension VoiceRecorderViewModel {
    func voiceRecoderCellTapped(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            // 선택한 녹음 파일이 현재 선택되어있는 녹음파일이 아니면 재생정지
            stopPlaying()
            selectedRecordedFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    // 알럿에서 삭제 버튼 눌렀을 때 호출될 예정
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            stopPlaying()
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            // 실제로는 오류처리를 하고 확인을 눌렀을 때, 다시 시도를 하거나 다시 서버 데이터를 호출하는 동작이 필요함. 그러나 로컬에서 알럿을 표현하는 방법으로만 진행
            displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceRecoderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        alertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음 관련 메서드
extension VoiceRecorderViewModel {
    func recorderBtnTapped() {
        selectedRecordedFile = nil
        
        if isPlaying {
            stopPlaying()
            startRecording()
        } else if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        // 해당 녹음파일이 저장될 위치를 파일 매니저를 통해 저장되는 파일 이름을 담아 url을 생성한다.
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
        let settings = [  // 녹음 파일이 어떤 형식으로 저장될지 설정해준다.
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),  // 오디오 녹음 파일의 포맷 설정
            AVSampleRateKey: 12000,  // 오디오 샘플링 비율 설정
            AVNumberOfChannelsKey: 1,  // 오디오 녹음 파일의 채널 수 지정
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue  // 오디오 인코더의 품질 지정
        ]
        
        do {
            // AudioRecorder 인스턴스 생성시 어디에 저장될지 url과 어떤 설정을 가질지 settings 파라미터를 두어 인스턴스를 생성한다.
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    // 녹음 종료하기
    private func stopRecording() {
        audioRecorder?.stop()  // 녹음 중지
        self.recordedFiles.append(self.audioRecorder!.url)  // 해당 녹음 파일의 url 경로를 추가해줌
        self.isRecording = false
    }
    
    // 파일 매니저의 저장된 파일 url 경로를 탐색하여 반환해줌
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
    func startPlaying(recordingURL: URL) {
        do {
            // 어떤 파일을 재생할지 contentsOf 파라미터에 받아온 음성메모 파일 url을 주입하여 생성
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self  // delegete 메서드를 위해 지정
            audioPlayer?.play()
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(
                withTimeInterval: 0.1,
                repeats: true) { _ in
                    self.updateCurrentTime()
                }
        } catch {
            displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    // 종료
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    // 일시정지
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    // 재개
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    // 뷰에서 플레이어들을 가지고 파일정보를 가져오는 것 (시간과 타임인터벌로 가져옴)
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as?Date
        } catch {
            displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
        }
        
        return (creationDate, duration)
    }
}
