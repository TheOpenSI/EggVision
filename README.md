🥚 EggVision  
EggVision is an iOS-based capstone project that classifies egg types (chicken or quail) and predicts the gender of unhatched chicks for chicken eggs using LiDAR-based shape analysis. It offers a humane and efficient solution to reduce the mass culling of male chicks in the poultry industry by analyzing egg morphology.

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Features  
- Detect and classify egg type (chicken or quail) using CoreML  
- Predict chick gender for chicken eggs using Shape Index  
- Automatically measure egg dimensions using LiDAR and SceneKit  
- Manual input option for Shape Index-based predictions  
- Clean SwiftUI interface  

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Gender Prediction Logic  
This app uses a rule-based gender prediction system based on the threshold values from Kayadan & Uzun (2023). No separate machine learning model is used for gender classification.

Formula:  
Shape Index (SI) = Short Axis / Long Axis

If SI > 0.50 → Likely Female  
If SI ≤ 0.50 → Likely Male

Measurements can be taken automatically using LiDAR or entered manually by the user.

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Getting Started  

Requirements:  
- macOS with Xcode 15 or later  
- iPhone Pro model with LiDAR (e.g., iPhone 13 Pro, 14 Pro, 15 Pro)  

Instructions:  
1. Clone the repository  
   git clone https://github.com/H-Shahriar/EggVision.git  

2. Open the project in Xcode  

3. Connect your LiDAR-enabled iPhone and run the app  

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Screenshots  

Home Screen  
- screenshots/home.png

Egg Classification Result  
- screenshots/type-classification.png

LiDAR Scan in Progress  
- screenshots/lidar-scan.png

Gender Prediction Output  
- screenshots/gender-result.png

(If you want to add screenshots, please name and organize them inside a /screenshots folder in the repo.)

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Tech Stack  
- Swift / SwiftUI  
- CoreML for egg type classification  
- ARKit + SceneKit for LiDAR scanning  
- Custom rule-based gender prediction system  

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

Credits  
Developed by Hasan Shahriar  
Sponsored by Harmony Harvesty Farm  
Capstone Project – University of Canberra, 2025  
Based on the research: Kayadan & Uzun (2023)  

––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

License  

MIT License  

Copyright (c) 2024-2025 Open Source Institute

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

1. The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.  

2. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.  

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

