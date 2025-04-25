import SwiftUI

struct ManualGenderInputView: View {
    @State private var shortAxis: String = "43.16"
    @State private var longAxis: String = "60.35"
    @State private var shapeIndexAuto: Double = 0.0
    @State private var genderResult: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Egg Dimensions (MM)")) {
                    TextField("Short Axis (mm)", text: $shortAxis)
                        .keyboardType(.decimalPad)
                    TextField("Long Axis (mm)", text: $longAxis)
                        .keyboardType(.decimalPad)
                }
                .onChange(of: shortAxis) { recalculateFeatures() }
                .onChange(of: longAxis) { recalculateFeatures() }

                Section(header: Text("Shape Index")) {
                    Text("Auto Shape Index: \(String(format: "%.3f", shapeIndexAuto))")
                }

                Section {
                    Button("Predict Gender") {
                        predictGender()
                    }
                    .buttonStyle(.borderedProminent)
                }

                if !genderResult.isEmpty {
                    Section(header: Text("Prediction Result")) {
                        Text("🔍 Predicted Gender: \(genderResult)")
                            .font(.headline)
                            .foregroundColor(genderResult == "Female" ? .pink : .blue)
                    }
                }
            }
            .navigationTitle("Gender Predictor")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                recalculateFeatures()
            }
        }
    }

    func recalculateFeatures() {
        guard let sa = Double(shortAxis), let la = Double(longAxis), la != 0 else { return }
        shapeIndexAuto = sa / la
    }

    func predictGender() {
        guard let sa = Double(shortAxis), let la = Double(longAxis), la != 0 else {
            genderResult = "⚠️ Invalid dimensions"
            return
        }

        let shapeIndex = sa / la
        genderResult = shapeIndex >= 0.5017 ? "Female" : "Male"
    }
}

struct ManualGenderInputView_Previews: PreviewProvider {
    static var previews: some View {
        ManualGenderInputView()
    }
}
    
