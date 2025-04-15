import SwiftUI
import UIKit
import CoreML

struct ContentView: View {
    @State private var image: UIImage?
    @State private var classificationLabel: String = "Select an image to classify"
    @State private var showingImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var scannedGender: String = ""
    @State private var fadeIn = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {

                    Image(systemName: "egg.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.yellow)
                        .padding(.top)

                    Text("EggVision")
                        .font(.largeTitle)
                        .bold()
                        .opacity(fadeIn ? 1 : 0)
                        .onAppear {
                            withAnimation(.easeIn(duration: 1.2)) {
                                fadeIn = true
                            }
                        }

                    Text("Predict egg type and chick gender — fast, easy, and ethical 🐣")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Group {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                                .cornerRadius(10)
                        } else {
                            Text("No Image Selected")
                                .foregroundColor(.gray)
                                .padding()
                        }

                        Text(classificationLabel)
                            .font(.headline)

                        if !scannedGender.isEmpty {
                            Text("🔬 LiDAR Prediction: \(scannedGender)")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }

                    sectionHeader("📸 Image-Based Classification")

                    HStack(spacing: 16) {
                        Button("🖼 Gallery") {
                            sourceType = .photoLibrary
                            showingImagePicker = true
                        }

                        Button("📷 Camera") {
                            sourceType = .camera
                            showingImagePicker = true
                        }
                    }
                    .buttonStyle(.borderedProminent)

                    sectionHeader("🧮 Manual Input")

                    NavigationLink("✏️ Enter Features Manually") {
                        ManualGenderInputView()
                    }
                    .buttonStyle(.borderedProminent)

                    sectionHeader("📡 3D Egg Scan")

                    NavigationLink("📡 Scan with LiDAR") {
                        LiDARGenderScanView(genderResult: $scannedGender)
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(selectedImage: $image, sourceType: sourceType)
            }
            .onChange(of: image) { _, _ in
                if let uiImage = image {
                    classifyImage(uiImage)
                }
            }
        }
    }

    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
    }

    func classifyImage(_ image: UIImage) {
        do {
            let eggTypeModel = try keras_model(configuration: MLModelConfiguration())
            guard let inputArray = image.toMLMultiArray() else {
                classificationLabel = "⚠️ Failed to process image"
                return
            }

            let prediction = try eggTypeModel.prediction(sequential_1_input: inputArray)
            let eggType = prediction.classLabel
            classificationLabel = "🥚 Egg Type: \(eggType)"

        } catch {
            classificationLabel = "⚠️ Classification error: \(error.localizedDescription)"
        }
    }
}

