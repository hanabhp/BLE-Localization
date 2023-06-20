# Precision in Imperfect Maps: Unlocking Indoor Localization through Fingerprint-based Interpolation in Incomplete Radio Maps

## Abstract

Indoor localization plays a crucial role in the next generation of Industry 5.0, enabling efficient asset tracking, navigation, and process optimization. However, traditional localization methods like Global Navigation Satellite Systems (GNSS) face limitations in terms of accuracy, power consumption, and cost in indoor environments. Bluetooth Low Energy (BLE) technology and fingerprint method are the most popular ways that can be used for indoor localization tailored for short-range networks.

While fingerprint-based localization provides accurate position estimation, it suffers from drawbacks such as the need for a complete map and frequent map updates. To overcome the limitation of incomplete signal maps in fingerprint-based localization, this paper proposes a new method that incorporates fuzzy clustering to generate candidate locations and weighted interpolation to estimate the final location in incomplete fingerprint map situations by considering the environment structure (focused on the effect of walls on the signal in the environment). For this purpose, we used a Neural Network (NN) to approximate the location of objects relative to walls to provide more precise weights for candidate positions to enhance the estimation accuracy.

For the evaluation of the proposed method, a testbed in an office environment is implemented to demonstrate the effectiveness of the proposed method in achieving accurate indoor localization. Based on the results, a 15% positioning accuracy improvement can be achieved, showing the potential of our approach for real-world applications in the industry.

