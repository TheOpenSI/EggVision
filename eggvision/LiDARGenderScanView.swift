import SwiftUI
import ARKit
import SceneKit
import AVFoundation

struct LiDARGenderScanView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var genderResult: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let arViewController = ARViewController()
        arViewController.delegate = context.coordinator
        return arViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    class Coordinator: NSObject, ARViewControllerDelegate {
        let parent: LiDARGenderScanView

        init(_ parent: LiDARGenderScanView) {
            self.parent = parent
        }

        func didPredictGender(_ gender: String) {
            self.parent.genderResult = gender
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

protocol ARViewControllerDelegate: AnyObject {
    func didPredictGender(_ gender: String)
}

class ARViewController: UIViewController, ARSCNViewDelegate {
    weak var delegate: ARViewControllerDelegate?
    
    private var sceneView: ARSCNView!
    private let configuration = ARWorldTrackingConfiguration()
    private let statusLabel = UILabel()
    private let resultLabel = UILabel()
    private let shortAxisLabel = UILabel()
    private let longAxisLabel = UILabel()
    private let countdownLabel = UILabel()
    private var captureButton: UIButton!
    private var rescanButton: UIButton!
    private var isCountingDown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.frame)
        view.addSubview(sceneView)
        sceneView.delegate = self
        sceneView.debugOptions = [.showFeaturePoints]
        
        configuration.sceneReconstruction = .mesh
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
        
        setupStatusLabel()
        setupResultLabel()
        setupCountdownLabel()
        setupCaptureButton()
        setupRescanButton()
        setupDimensionLabels()
        speak("Move your phone slowly around the egg")
    }
    
    func setupStatusLabel() {
        statusLabel.text = "Move your phone slowly around the egg..."
        statusLabel.textAlignment = .center
        statusLabel.textColor = .white
        statusLabel.font = UIFont.boldSystemFont(ofSize: 16)
        statusLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    func setupResultLabel() {
        resultLabel.text = ""
        resultLabel.textAlignment = .center
        resultLabel.textColor = .white
        resultLabel.font = UIFont.boldSystemFont(ofSize: 22)
        resultLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.9)
        resultLabel.layer.cornerRadius = 12
        resultLabel.clipsToBounds = true
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.alpha = 0.0
        view.addSubview(resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 220),
            resultLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    func setupDimensionLabels() {
        [shortAxisLabel, longAxisLabel].forEach { label in
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0
            view.addSubview(label)
        }

        NSLayoutConstraint.activate([
            shortAxisLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 12),
            shortAxisLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            longAxisLabel.topAnchor.constraint(equalTo: shortAxisLabel.bottomAnchor, constant: 4),
            longAxisLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    
    func setupCountdownLabel() {
        countdownLabel.text = ""
        countdownLabel.textAlignment = .center
        countdownLabel.textColor = .white
        countdownLabel.font = UIFont.boldSystemFont(ofSize: 48)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.alpha = 0
        view.addSubview(countdownLabel)
        
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setupCaptureButton() {
        captureButton = UIButton(type: .system)
        captureButton.setTitle("📏 Capture Egg", for: .normal)
        captureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        captureButton.backgroundColor = UIColor.systemBlue
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.layer.cornerRadius = 10
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(startCountdown), for: .touchUpInside)
        
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([
            captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.widthAnchor.constraint(equalToConstant: 160),
            captureButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupRescanButton() {
        rescanButton = UIButton(type: .system)
        rescanButton.setTitle("🔄 Rescan", for: .normal)
        rescanButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        rescanButton.backgroundColor = UIColor.systemGray
        rescanButton.setTitleColor(.white, for: .normal)
        rescanButton.layer.cornerRadius = 10
        rescanButton.translatesAutoresizingMaskIntoConstraints = false
        rescanButton.addTarget(self, action: #selector(rescan), for: .touchUpInside)
        
        view.addSubview(rescanButton)
        NSLayoutConstraint.activate([
            rescanButton.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -10),
            rescanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rescanButton.widthAnchor.constraint(equalToConstant: 120),
            rescanButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc func rescan() {
        resultLabel.alpha = 0.0
        statusLabel.text = "Move your phone slowly around the egg..."
        speak("Rescan started")
        sceneView.scene.rootNode.enumerateChildNodes { node, _ in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    @objc func startCountdown() {
        guard !isCountingDown else { return }
        isCountingDown = true
        var countdown = 3
        countdownLabel.text = "3"
        countdownLabel.alpha = 1
        speak("Starting scan in 3")
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            countdown -= 1
            if countdown == 0 {
                timer.invalidate()
                self.countdownLabel.alpha = 0
                self.captureEgg()
                self.isCountingDown = false
            } else {
                self.countdownLabel.text = "\(countdown)"
            }
        }
    }
    
    func speak(_ message: String) {
        let utterance = AVSpeechUtterance(string: message)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        AVSpeechSynthesizer().speak(utterance)
    }
    
    @objc func captureEgg() {
        statusLabel.text = "Analyzing shape..."
        
        guard let frame = sceneView.session.currentFrame else { return }
        let meshAnchors = frame.anchors.compactMap { $0 as? ARMeshAnchor }
        guard let mesh = meshAnchors.first else {
            statusLabel.text = "⚠️ No egg detected — move your phone more."
            return
        }
        
        // Extract all mesh points safely
        let vertices = mesh.geometry.vertices
        let vertexCount = vertices.count
        let vertexBuffer = vertices.buffer.contents()
        var points: [SIMD3<Float>] = []
        
        for i in 0..<vertexCount {
            let offset = vertices.offset + i * vertices.stride
            var vertex = SIMD3<Float>(repeating: 0)
            memcpy(&vertex, vertexBuffer.advanced(by: offset), MemoryLayout<SIMD3<Float>>.size)
            let worldVertex = mesh.transform * SIMD4<Float>(vertex, 1.0)
            points.append(SIMD3<Float>(worldVertex.x, worldVertex.y, worldVertex.z))
        }
        
        // Step 1: Filter points near camera center
        let cameraPos = frame.camera.transform.columns.3
        let center = SIMD3<Float>(cameraPos.x, cameraPos.y, cameraPos.z)
        var filteredPoints = points.filter { simd_distance($0, center) < 0.6 }

        
        // Step 2: Optional - filter by height (ignore table/floor)
        if let lowest = filteredPoints.min(by: { $0.y < $1.y }) {
            filteredPoints = filteredPoints.filter { $0.y > lowest.y + 0.005 && $0.y < lowest.y + 0.12 }
        }
        
        guard !filteredPoints.isEmpty else {
            statusLabel.text = "⚠️ Not enough egg points — try scanning again."
            return
        }
        
        // Bounding box from filtered points
        let minPoint = filteredPoints.reduce(filteredPoints[0]) { simd_min($0, $1) }
        let maxPoint = filteredPoints.reduce(filteredPoints[0]) { simd_max($0, $1) }
        let size = maxPoint - minPoint
        
        // Convert to mm
        let longAxis = Double(max(size.x, size.z)) * 1000.0
        let shortAxis = Double(min(size.x, size.z)) * 1000.0
        let shapeIndex = shortAxis / longAxis
        
        // Predict gender using shape index threshold
        let gender = shapeIndex >= 0.5017 ? "Female" : "Male"
        
        DispatchQueue.main.async {
            self.resultLabel.text = "Result: \(gender)"
            self.shortAxisLabel.text = "📏 Short Axis: \(String(format: "%.2f", shortAxis)) mm"
            self.longAxisLabel.text = "📏 Long Axis: \(String(format: "%.2f", longAxis)) mm"

            UIView.animate(withDuration: 0.3) {
                self.resultLabel.alpha = 1.0
                self.shortAxisLabel.alpha = 1.0
                self.longAxisLabel.alpha = 1.0
            }

            self.statusLabel.text = "✅ Scan complete"
        }

        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        speak("Prediction complete. \(gender)")
        
        delegate?.didPredictGender(gender)
    }
}
