//  Step Into Vision - Labs
//
//  Title: Lab078
//
//  Subtitle: Building an glass material box
//
//  Description: Using spatialOverlay wrap any SwiftUI view in glass material panes.
//
//  Type: Volume
//
//  Created by Joseph Simpson on 8/21/25.

import SwiftUI
import RealityKit
import RealityKitContent

struct Lab078: View {

    @State var panes: Edge3D.Set = [.all]
    @State var padding: CGFloat = 24

    var body: some View {
        VStack {
            ModelViewSimple(name: "ToyRocket", bundle: realityKitContentBundle)
                .frame(width: 500, height: 500)
                .frame(depth: 500)
                .glassBackgroundBox(padding: padding, panes)
        }
        .ornament(attachmentAnchor: .scene(.trailing), contentAlignment: .leading, ornament: {
            VStack(spacing: 6) {

                Slider(value: $padding,
                       in: 0...96,
                       step: 1,
                       minimumValueLabel: Text("0"),
                       maximumValueLabel: Text("96"),
                       label: {
                    Text("Padding")
                })
                .frame(width: 200)

                HStack {

                    Button(action: {
                        if panes.contains(.vertical) {
                            panes.remove(.vertical)
                        } else {
                            panes.insert(.vertical)
                        }

                    }, label: {
                        Text("Vertical")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.top) {
                            panes.remove(.top)
                        } else {
                            panes.insert(.top)
                        }

                    }, label: {
                        Text("Top")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.bottom) {
                            panes.remove(.bottom)
                        } else {
                            panes.insert(.bottom)
                        }

                    }, label: {
                        Text("Bottom")
                            .frame(width: 80)
                    })

                }

                HStack {

                    Button(action: {
                        if panes.contains(.horizontal) {
                            panes.remove(.horizontal)
                        } else {
                            panes.insert(.horizontal)
                        }

                    }, label: {
                        Text("Horizontal")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.leading) {
                            panes.remove(.leading)
                        } else {
                            panes.insert(.leading)
                        }

                    }, label: {
                        Text("Leading")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.trailing) {
                            panes.remove(.trailing)
                        } else {
                            panes.insert(.trailing)
                        }

                    }, label: {
                        Text("Trailing")
                            .frame(width: 80)
                    })
                }

                HStack {

                    Button(action: {
                        if panes.contains(.depth) {
                            panes.remove(.depth)
                        } else {
                            panes.insert(.depth)
                        }

                    }, label: {
                        Text("Depth")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.front) {
                            panes.remove(.front)
                        } else {
                            panes.insert(.front)
                        }

                    }, label: {
                        Text("Front")
                            .frame(width: 80)
                    })

                    Button(action: {
                        if panes.contains(.back) {
                            panes.remove(.back)
                        } else {
                            panes.insert(.back)
                        }

                    }, label: {
                        Text("Back")
                            .frame(width: 80)
                    })

                }

                Button(action: {
                    if panes.contains(.all) {
                        panes.remove(.all)
                    } else {
                        panes.insert(.all)
                    }

                }, label: {
                    Text("All")
                        .frame(width: 80)
                })


            }
            .controlSize(.small)
            .padding()
            .glassBackgroundEffect()
        })
    }
}

extension View {
    func glassBackgroundBox(padding: CGFloat = 0, _ directions: Edge3D.Set) -> some View {

        // compute the display mode based on the edge set
        let topDisplayMode: GlassBackgroundDisplayMode = directions.contains(.top) || directions.contains(.all) || directions.contains(.vertical) ? .always : .never
        let bottomDisplayMode: GlassBackgroundDisplayMode = directions.contains(.bottom) || directions.contains(.all) || directions.contains(.vertical) ? .always : .never
        let leadingDisplayMode: GlassBackgroundDisplayMode = directions.contains(.leading) || directions.contains(.all) || directions.contains(.horizontal) ? .always : .never
        let trailingDisplayMode: GlassBackgroundDisplayMode = directions.contains(.trailing) || directions.contains(.all) || directions.contains(.horizontal) ? .always : .never
        let frontDisplayMode: GlassBackgroundDisplayMode = directions.contains(.front) || directions.contains(.all) || directions.contains(.depth) ? .always : .never
        let backDisplayMode: GlassBackgroundDisplayMode = directions.contains(.back) || directions.contains(.all) || directions.contains(.depth) ? .always : .never

        return spatialOverlay {
            ZStack {
                // Back
                Color.clear
                    .glassBackgroundEffect(displayMode: backDisplayMode)
                    .padding(padding)


                // Create the sides just the like back and front, but rotate them on y
                ZStack {
                    Color.clear
                        .glassBackgroundEffect(displayMode: leadingDisplayMode)
                        .padding(padding)
                    Spacer()
                    Color.clear
                        .glassBackgroundEffect(displayMode: trailingDisplayMode)
                        .padding(padding)
                }
                .rotation3DLayout(.degrees(90), axis: .y)

                // Front
                Color.clear
                    .glassBackgroundEffect(displayMode: frontDisplayMode)
                    .padding(padding)
            }



        }
        // Create the top and bottom with another overlay and rotate the panes on the X axis
        .spatialOverlay {
            ZStack {
                Color.clear
                    .glassBackgroundEffect(displayMode: bottomDisplayMode)
                    .padding(padding)
                Spacer()
                Color.clear
                    .glassBackgroundEffect(displayMode: topDisplayMode)
                    .padding(padding)
            }
            .rotation3DLayout(.degrees(90), axis: .x)
        }
    }
}

#Preview {
    Lab078()
}
