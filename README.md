# EggVision
This iOS application leverages the power of machine learning and LiDAR technology to classify and determine the type and gender of chicken and quail eggs.

## Features

* Egg Type Classification: Accurately identifies whether an egg is a chicken or a quail egg from an image.
* Gender Determination (Manual): Allows users to manually input the long axis and short axis sizes of an egg to determine its gender.
* Custom Dataset: Trained on a custom dataset of chicken and quail egg images, ensuring high accuracy.
* Data Augmentation: Utilized data augmentation techniques to expand the dataset and improve model robustness.
* MobileNetV2 Model: Employs the MobileNetV2 architecture for efficient and accurate image classification on mobile devices.
* LiDAR Integration (In Progress): Currently developing functionality to determine egg gender directly from real-time LiDAR camera data.

## Technologies Used

* Xcode: Integrated development environment (IDE) for iOS app development.
* Core ML: Apple's machine learning framework for integrating trained models into iOS applications.
* ARKit/LiDAR: For real-time depth sensing and 3D data capture (in progress).
* MobileNetV2: Lightweight and efficient convolutional neural network architecture.
* Custom Dataset: A curated dataset of chicken and quail egg images.
* Data Augmentation: Techniques like rotation, scaling, and flipping to increase dataset size.

## Installation

1.  Clone the repository to your local machine:
    ```bash
    git clone [repository URL]
    ```
2.  Open the project in **Xcode**.
3.  Ensure you have the necessary dependencies installed (e.g., via CocoaPods or Swift Package Manager, if applicable).
4.  Build and run the application on an iOS device or simulator using **Xcode**.

## Usage

1.  Egg Type Classification:
    * Capture an image of an egg using the camera or select an image from the photo library.
    * The app will classify the egg as either a chicken egg or a quail egg.
2.  Gender Determination (Manual):
    * After classifying the egg type, you can manually enter the long axis and short axis sizes of the egg.
    * The app will then determine the gender of the egg based on these measurements.
3.  LiDAR implementation (In Progress):
    * Once the lidar feature is implemented, user will be able to point the lidar camera towards the egg, and the app will automatically calculate the axis and provide the gender result.

## Future Enhancements

* Real-time LiDAR Gender Determination: Complete the implementation of real-time gender determination using LiDAR camera data.
* Data analytics: Add chart and visual data to show the result of the egg analysis.



