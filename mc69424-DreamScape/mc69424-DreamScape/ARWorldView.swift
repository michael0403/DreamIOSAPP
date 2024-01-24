//
// Project: ChengMichael-FinalProject
// EID: mc69424
// Course: CS329E
//
import SwiftUI
import RealityKit
import ARKit

struct ARWorldView: View {
    @State private var arView: ARView = ARView(frame: .zero)
    @EnvironmentObject var sharedViewModel: SharedViewModel
  

    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView, selectedModelName: sharedViewModel.selectedModelName ?? "defaultModel")
                            .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            setupARView()
        }
    }

    private func setupARView() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        arView.session.run(config)
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView
    var selectedModelName: String?

    func makeUIView(context: Context) -> ARView {
        arView.session.delegate = context.coordinator
        if let modelName = selectedModelName {
            placeObject(named: modelName, in: arView)
        }
        
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        if let modelName = selectedModelName {
            placeObject(named: modelName, in: uiView)
        }
    }

    func placeObject(named objectName: String, in arView: ARView) {
        let anchor = AnchorEntity(plane: .horizontal)

        arView.scene.addAnchor(anchor)

        if let entity = try? Entity.loadModel(named: objectName) {
            entity.generateCollisionShapes(recursive: true)
            anchor.addChild(entity)
        } else {
            print("Failed to load model \(objectName)")
        }
    }


    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer

        init(_ parent: ARViewContainer) {
            self.parent = parent
        }

        func session(_ session: ARSession, didFailWithError error: Error) {
        }

        func sessionWasInterrupted(_ session: ARSession) {
        }

        func sessionInterruptionEnded(_ session: ARSession) {
        }
    }
}
