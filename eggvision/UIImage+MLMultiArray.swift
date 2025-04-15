import UIKit
import CoreML
import Accelerate

extension UIImage {
    func toMLMultiArray() -> MLMultiArray? {
        let modelSize = 224  // Match the model's expected input size
        let shape: [NSNumber] = [1, 224, 224, 3]  // Ensure correct shape

        guard let resizedImage = self.resized(to: CGSize(width: modelSize, height: modelSize)),
              let cgImage = resizedImage.cgImage else { return nil }

        do {
            let array = try MLMultiArray(shape: shape, dataType: .float32)
            guard let pixelData = cgImage.dataProvider?.data else { return nil }
            let data = CFDataGetBytePtr(pixelData)

            for y in 0..<modelSize {
                for x in 0..<modelSize {
                    let index = (y * modelSize + x) * 4  // RGBA format
                    let r = (Float(data![index]) / 127.5) - 1.0  // Normalize (-1 to 1)
                    let g = (Float(data![index + 1]) / 127.5) - 1.0
                    let b = (Float(data![index + 2]) / 127.5) - 1.0

                    let pixelIndex = y * modelSize + x
                    array[pixelIndex] = NSNumber(value: r)
                    array[pixelIndex + modelSize * modelSize] = NSNumber(value: g)
                    array[pixelIndex + 2 * modelSize * modelSize] = NSNumber(value: b)
                }
            }
            return array
        } catch {
            print("⚠️ Error converting image to MLMultiArray: \(error)")
            return nil
        }
    }

    // Function to resize image correctly
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        self.draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

