//
//  GeometryReader.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 13/8/25.
//

import SwiftUI
import UIKit


struct HoldToFillDemo: View {
    // Timeline config
    private let totalDuration: TimeInterval = 10.0

    // Timeline state
    @State private var timelineStart: Date? = nil
    @State private var elapsed: TimeInterval = 0
    @State private var isRunning = false

    // Press state
    @State private var isPressing = false
    @State private var currentPressStart: TimeInterval? = nil

    // Recorded filled segments (in seconds along the 10s timeline)
    @State private var segments: [ClosedRange<Double>] = []

    // Looper
    @State private var tickTask: Task<Void, Never>? = nil

    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isRunning { startRun() }
                            if !isPressing {
                                isPressing = true
                                beginPress()
                            }
                        }
                        .onEnded { _ in
                            isPressing = false
                            endPress()
                        }
                )

            VStack {
                
                Spacer()
                
                Text(statusText)
                    .font(.headline)
                
                VStack(spacing: 20) {
                    
                    SegmentedProgressBar(
                        totalDuration: totalDuration,
                        elapsed: elapsed,
                        segments: segments
                    )
                    .frame(height: 18)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    
                    HStack(spacing: 12) {
                        Button(isRunning ? "Stop" : "Start") {
                            isRunning ? stopRun() : startRun()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Reset") {
                            reset()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.bottom, 30)
                .background(.surfaceBg)
                .cornerRadius(24, corners: [.topLeft, .topRight])
            }
        }
        .withGradientBackground()
        .navigationTitle("New Vibration")
        .ignoresSafeArea(edges: .all)
        .onDisappear { stopRun() }
    }

    private var statusText: String {
        if !isRunning { return "Press & hold anywhere (10s pass)" }
        return isPressing ? "Recording…" : "Idle…"
    }

    // MARK: - Timeline control

    private func startRun() {
        reset(keepSegments: true) // keep any prior UI state until new run starts
        isRunning = true
        elapsed = 0
        
        segments = []
        timelineStart = Date()

        tickTask?.cancel()
        tickTask = Task {
            let frameNs: UInt64 = 16_000_000 // ~60 FPS
            while !Task.isCancelled, isRunning {
                let now = Date()
                let e = now.timeIntervalSince(timelineStart ?? now)
                await MainActor.run {
                    elapsed = min(totalDuration, e)

                    // If currently pressing, update the "open" segment live
                    if let start = currentPressStart, elapsed >= start {
                        updateOpenSegment(to: elapsed)
                    }

                    // Auto-stop at end
                    if elapsed >= totalDuration {
                        finalizeOpenSegment(at: totalDuration)
                        stopRun()
                    }
                }
                try? await Task.sleep(nanoseconds: frameNs)
            }
        }
    }

    private func stopRun() {
        isRunning = false
        isPressing = false
        tickTask?.cancel()
        tickTask = nil
    }

    private func reset(keepSegments: Bool = false) {
        stopRun()
        timelineStart = nil
        elapsed = 0
        currentPressStart = nil
        if !keepSegments { segments = [] }
    }

    // MARK: - Press handling → segments

    private func beginPress() {
        let startPoint = elapsed
        currentPressStart = startPoint
        // Start a new “open” segment as zero-length; it will grow while holding.
        segments.append(clampRange(startPoint...startPoint))
    }

    private func endPress() {
        finalizeOpenSegment(at: elapsed)
    }

    private func updateOpenSegment(to current: Double) {
        guard !segments.isEmpty, let start = currentPressStart else { return }
        let idx = segments.count - 1
        let clamped = clampRange(start...current)
        segments[idx] = clamped
    }

    private func finalizeOpenSegment(at endPoint: Double) {
        guard let start = currentPressStart, !segments.isEmpty else { return }
        let idx = segments.count - 1
        var r = clampRange(start...endPoint)

        // If the user tapped extremely quickly or there was jitter,
        // ensure non-negative width.
        if r.upperBound < r.lowerBound { r = r.lowerBound...r.lowerBound }

        segments[idx] = r
        currentPressStart = nil
    }

    // MARK: - Helpers

    private func clampRange(_ r: ClosedRange<Double>) -> ClosedRange<Double> {
        let lower = max(0, min(r.lowerBound, totalDuration))
        let upper = max(0, min(r.upperBound, totalDuration))
        return lower...upper
    }
}


//MARK: SegmentedProgressBar
struct SegmentedProgressBar: View {
    let totalDuration: Double
    let elapsed: Double
    let segments: [ClosedRange<Double>]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Base
                RoundedRectangle(cornerRadius: geo.size.height/2)
                    .fill(.blue)

                // Filled segments
                ForEach(Array(segments.enumerated()), id: \.offset) { _, seg in
                    let x = geo.size.width * (seg.lowerBound / totalDuration)
                    let w = geo.size.width * ((seg.upperBound - seg.lowerBound) / totalDuration)
                    RoundedRectangle(cornerRadius: geo.size.height/2)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: max(0, w))
                        .offset(x: x)
                        .animation(.default, value: segments.count)
                }

                // Playhead
                let playX = geo.size.width * (elapsed / totalDuration)
                Rectangle()
                    .fill(.primary.opacity(0.5))
                    .frame(width: 2)
                    .offset(x: max(0, min(playX - 1, geo.size.width - 2)))
            }
        }
    }
}


#Preview {
    HoldToFillDemo()
}
