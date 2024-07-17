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
    @Published var isDisplayRemoveVoiceRecoderAlert: Bool  // 삭제 알럿
    @Published var isDisplayAlert: Bool  // 에러 알럿
    @Published var alertMessage: String
    
    /// 음성메모 녹음 관련 프로퍼티
    var audioRecoder: AVAudioRecorder?
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
extension VoiceRecorderViewModel {
    func voiceRecoderCellTapped(_ recordedFile: URL) {
        if selectedRecordedFile != recordedFile {
            // 선택한 녹음 파일이 현재 선택되어있는 녹음파일이 아니면
            // TODO: - 재생정지 메서드 호출
            stopPlaying()
            selectedRecordedFile = recordedFile
        }  // 선택한 녹음 파일이 현재 선택되어있는 녹음파일이면 딱히 해줄 건 없음
    }
    
    func removeBtnTapped() {
        // TODO: - 삭제 얼럿 노출을 위한 상태 변경 메서드 호출
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    // 알럿에서 삭제 버튼 눌렀을 때 호출될 예정
    func removeSelectedVoiceRecord() {
        guard let fileToRemove = selectedRecordedFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            // TODO: - 선택된 음성메모를 찾을 수 없다는 에러 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecordedFile = nil
            // TODO: - 재생 정지 메서드 호출
            stopPlaying()
            // TODO: - 삭제 성공 얼럿 노출
            displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
        } catch {
            // TODO: - 삭제 실패 오류 얼럿 노출
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
        
        if isPlaying {  // 재생 중일 때
            // TODO: - 재생 정지 메서드 호출
            stopPlaying()
            
            // TODO: - 재생 시작 메서드 호츌
            startRecording()
        } else if isRecording {  // 녹음 중일 때
            // TODO: - 녹음 정지 메서드 호출
            stopRecording()
        } else {  // 재생도 녹음도 안하고 있을 때
            // TODO: - 녹음 시작 메서드 호출
            startRecording()
        }
    }
    
    // 녹음 시작하기
    private func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),  // 오디오 녹음 파일의 포맷 설정
            AVSampleRateKey: 12000,  // 오디오 샘플링 비율 설정
            AVNumberOfChannelsKey: 1,  // 오디오 녹음 파일의 채널 수 지정
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue  // 오디오 인코더의 품질 지정
        ]
        
        do {
            audioRecoder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecoder?.record()
            self.isRecording = true
        } catch {
            displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    // 녹음 종료하기
    private func stopRecording() {
        audioRecoder?.stop()  // 녹음 중지
        self.recordedFiles.append(self.audioRecoder!.url)  // 현재까지 녹음한 파일 추가
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
    // 음성메모 파일 재생
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
                    // TODO: - 현재 시간 업데이트 메서드 호출
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
