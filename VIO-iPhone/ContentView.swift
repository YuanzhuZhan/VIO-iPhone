//
//  ContentView.swift
//  VIO-iPhone
//
//  Created by ZYZ on 6/17/25.
//
import ARKit
import Network
import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        
        let config = ARWorldTrackingConfiguration()
        config.worldAlignment = .gravity
        arView.session.run(config)
        
        arView.session.delegate = context.coordinator

        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: ARViewContainer
        let connection: NWConnection

        init(parent: ARViewContainer) {
            self.parent = parent
            connection = NWConnection(host:"192.168.1.25", port: 9000, using: .udp)
            connection.start(queue: .main)
        }

        func session(_ session: ARSession, didUpdate frame: ARFrame) {
            switch frame.camera.trackingState {
            case .normal:
                // OK: tracking is good, send VIO data
                break
            case .limited(let reason):
                print("Tracking limited: \(reason)")
                return
            case .notAvailable:
                print("Tracking not available")
                return
            }
            let transform = frame.camera.transform
            let position = SIMD3<Float>(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
            let rotation = simd_quatf(transform)
            print("Position: x=\(position.x), y=\(position.y), z=\(position.z)")
            print("Rotation (quat): x=\(rotation.imag.x), y=\(rotation.imag.y), z=\(rotation.imag.z), w=\(rotation.real)")
            let msg = "\(position.x), \(position.y), \(position.z), \(rotation.vector.x), \(rotation.vector.y), \(rotation.vector.z), \(rotation.vector.w)"
            if let data = msg.data(using: .utf8) {
                connection.send(content: data, completion: .contentProcessed({_ in }))
            }
        }
    }

}

#Preview {
    ContentView()
}
