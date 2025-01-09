//
//  RippleEffect.swift
//  BuddyCheck
//
//  Created by JP Norton on 1/1/25.
//


import SwiftUI

// MARK: - Ripple Effect Modifiers

/// A modifier that performs a ripple effect to its content
/// whenever its `trigger` value changes.
struct RippleEffect<T: Equatable>: ViewModifier {
    var origin: CGPoint
    var trigger: T
    
    init(at origin: CGPoint, trigger: T) {
        self.origin = origin
        self.trigger = trigger
    }
    
    func body(content: Content) -> some View {
        if #available(iOS 18.0, *) {
            let duration = self.duration
            let origin = self.origin

            return AnyView(
                content.keyframeAnimator(
                    initialValue: 0,
                    trigger: trigger
                ) { view, elapsedTime in
                    view.modifier(
                        RippleModifier(
                            origin: origin,
                            elapsedTime: elapsedTime,
                            duration: duration
                        )
                    )
                } keyframes: { _ in
                    MoveKeyframe(0)
                    LinearKeyframe(duration, duration: duration)
                }
            )
        } else {
            // Fallback for earlier iOS versions
            return AnyView(content)
        }
    }
    
    var duration: TimeInterval { 3 }
}

/// A modifier that applies a ripple shader to its content.
struct RippleModifier: ViewModifier {
    var origin: CGPoint
    
    var elapsedTime: TimeInterval
    var duration: TimeInterval
    
    // Adjust these to tweak the ripple look:
    var amplitude: Double = 12
    var frequency: Double = 15
    var decay: Double = 8
    var speed: Double = 1200
    
    func body(content: Content) -> some View {
        let shader = ShaderLibrary.Ripple(
            .float2(origin),
            .float(elapsedTime),
            .float(amplitude),
            .float(frequency),
            .float(decay),
            .float(speed)
        )
        
        content.visualEffect { view, _ in
            view.layerEffect(
                shader,
                maxSampleOffset: CGSize(width: amplitude, height: amplitude),
                isEnabled: 0 < elapsedTime && elapsedTime < duration
            )
        }
    }
}

// MARK: - Spatial Pressing Gesture

/// Allows capturing the "pressing" location in a SwiftUI coordinate space.
struct SpatialPressingGestureModifier: ViewModifier {
    var onPressingChanged: (CGPoint?) -> Void
    
    @State private var currentLocation: CGPoint?
    
    func body(content: Content) -> some View {
        let gesture = SpatialPressingGesture(location: $currentLocation)
        
        if #available(iOS 18.0, *) {
            content
                .gesture(gesture)
                .onChange(of: currentLocation, initial: false) { _, location in
                    onPressingChanged(location)
                }
        } else {
            // Fallback on earlier versions
        }
    }
}

extension View {
    func onPressingChanged(_ action: @escaping (CGPoint?) -> Void) -> some View {
        modifier(SpatialPressingGestureModifier(onPressingChanged: action))
    }
}

/// Wraps a `UILongPressGestureRecognizer` to get continuous location updates.
struct SpatialPressingGesture: UIGestureRecognizerRepresentable {
    
    final class Coordinator: NSObject, UIGestureRecognizerDelegate {
        @objc
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer
        ) -> Bool {
            // Allows this gesture to co-exist with others
            true
        }
    }
    
    @Binding var location: CGPoint?
    
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        Coordinator()
    }
    
    func makeUIGestureRecognizer(context: Context) -> UILongPressGestureRecognizer {
        let recognizer = UILongPressGestureRecognizer()
        recognizer.minimumPressDuration = 0
        recognizer.delegate = context.coordinator
        return recognizer
    }
    
    func handleUIGestureRecognizerAction(
        _ recognizer: UIGestureRecognizerType,
        context: Context
    ) {
        switch recognizer.state {
            case .began, .changed:
                // location in the *provided* coordinate space
                location = context.converter.localLocation
            case .ended, .cancelled, .failed:
                location = nil
            default:
                break
        }
    }
}
