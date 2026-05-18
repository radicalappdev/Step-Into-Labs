//  Step Into Vision - Labs
//
//  Title: Lab111
//
//  Subtitle: Progressive Page Indicator
//
//  Description: Building a timer progress capsule in SwiftUI
//
//  Type: Window
//
//  Featured: true
//
//  Created by Joseph Simpson on 5/18/26.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab111: View {
    var body: some View {
        TabView {
            Tab("Lab Pages", systemImage: "rectangle.stack") {
                LabPageIndicatorExample()
            }

            Tab("Tab Values", systemImage: "number.square") {
                DirectValueIndicatorExample()
            }
        }
    }
}

fileprivate struct LabPageIndicatorExample: View {
    @State private var currentPage = LabPage.red
    @State private var progress = 0.0

    private let pageDuration = 4.0
    private let timerStep: UInt64 = 50_000_000

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                Tab(value: LabPage.red) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepRed)
                }

                Tab(value: LabPage.green) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepGreen)
                }

                Tab(value: LabPage.blue) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepBlue)
                }
            }
            // use page style, but hide the page indicators
            .tabViewStyle(.page(indexDisplayMode: .never))

            PageControlIndicator(
                count: LabPage.allCases.count,
                current: currentPage.index,
                progress: progress
            )
            .padding(.bottom, 28)
        }
        .task(id: currentPage) {
            await runPageTimer()
        }
    }

    private func runPageTimer() async {
        progress = 0
        let startDate = Date()

        while !Task.isCancelled {
            let elapsed = Date().timeIntervalSince(startDate)
            progress = min(elapsed / pageDuration, 1)

            if progress >= 1 {
                currentPage = currentPage.next
                return
            }

            try? await Task.sleep(nanoseconds: timerStep)
        }
    }
}

fileprivate struct DirectValueIndicatorExample: View {
    @State private var currentPage = 0
    @State private var progress = 0.0

    private let pageCount = 3
    private let pageDuration = 4.0
    private let timerStep: UInt64 = 50_000_000

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $currentPage) {
                Tab(value: 0) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepRed)
                }

                Tab(value: 1) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepGreen)
                }

                Tab(value: 2) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.stepBlue)
                }
            }
            // use page style, but hide the page indicators
            .tabViewStyle(.page(indexDisplayMode: .never))

            PageControlIndicator(
                count: pageCount,
                current: currentPage,
                progress: progress
            )
            .padding(.bottom, 28)
        }
        .task(id: currentPage) {
            await runPageTimer()
        }
    }

    private func runPageTimer() async {
        progress = 0
        let startDate = Date()

        while !Task.isCancelled {
            let elapsed = Date().timeIntervalSince(startDate)
            progress = min(elapsed / pageDuration, 1)

            if progress >= 1 {
                currentPage = (currentPage + 1) % pageCount
                return
            }

            try? await Task.sleep(nanoseconds: timerStep)
        }
    }
}

fileprivate enum LabPage: Int, CaseIterable, Hashable {
    case red
    case green
    case blue

    var index: Int {
        rawValue
    }

    var next: LabPage {
        let nextIndex = (index + 1) % Self.allCases.count
        return Self.allCases[nextIndex]
    }
}

fileprivate struct PageControlIndicator: View {
    let count: Int
    let current: Int
    let progress: Double    // 0.0 -> 1.0

    private let dotSize: CGFloat = 8
    private let pillWidth: CGFloat = 36
    private let height: CGFloat = 8

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { i in
                if i == current {
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.35))
                            .frame(width: pillWidth, height: height)
                        Capsule()
                            .fill(.white)
                            .frame(width: pillWidth * progress, height: height)
                            .animation(.linear(duration: 0.05), value: progress)
                    }
                } else {
                    Circle()
                        .fill(.white.opacity(i < current ? 0.7 : 0.35))
                        .frame(width: dotSize, height: dotSize)
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: current)
    }
}

#Preview {
    Lab111()
}
