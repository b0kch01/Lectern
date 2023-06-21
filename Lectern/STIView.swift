//
//  STIView.swift
//  Lectern
//
//  Created by Paul Wong on 6/20/23.
//

import SwiftUI
import FluidGradient

struct STIView: View {

    @Environment(\.colorScheme) var colorScheme

    @State var fake: CGFloat = 0.0

    @State var primaryColor: Color = .blue
    @State var secondaryColor: Color = .cyan
    @State var tertiaryColor: Color = .mint

    @State var showPopup = false
    @State var showCalendar = false

    var body: some View {
        TabView {
            ForEach(0..<3, id: \.self) { _ in
                main
                    .simultaneousGesture(showCalendar ? nil : drag)
                    .simultaneousGesture(showCalendar ? nil : fakeDrag)
                    .ignoresSafeArea(.container)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
        .background(Color.black.ignoresSafeArea())
        .overlay(
            VStack(spacing: 0) {
                Spacer()

                Bar(color: Color(.secondarySystemFill))
                    .padding(.horizontal, 30)

                HStack(spacing: 7) {
//                    if vm.shipState == nil {
//                        if !vm.showAI {
                            Spacer()
//                        }

                        Button(action: {
                            withAnimation(.smooth) {
                                showPopup = true
                            }
                        }) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 21))
                        }
                        .fullScreenCover(isPresented: $showPopup) {
                            CenterStack {
                                VStack(spacing: 10) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.largeTitle.weight(.medium))
                                        .padding(.bottom, 10)

                                    Text("Some Warning Title")
                                        .font(.title3.weight(.semibold))

                                    Text("Some Warning Description")
                                        .font(.body)
                                }
                            }
                            .foregroundStyle(.white.opacity(0.9))
                            .background(
                                Color.blue.ignoresSafeArea()
                                    .opacity(0.9)
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:
                                        UIConstants.screenIsRounded ? UIConstants.screenRadius : UIConstants.screenRadius,
                                    style: .continuous
                                )
                            )
                            .background(BackgroundClearView())
                            .ignoresSafeArea()
                            .overlay(
                                HStack(spacing: 5) {
                                    Image(systemName: "xmark")
                                        .font(.callout.weight(.semibold))

                                    Text("Dismiss")
                                        .font(.callout.weight(.semibold))
                                }
                                .foregroundStyle(.white)
                                .padding(.vertical, 9)
                                .padding(.horizontal, 13)
                                .background(.primary)
                                .clipShape(RoundedRectangle(cornerRadius: 39, style: .continuous))
                                .shadow(color: Color.black.opacity(0.1), radius: 20)
                                .padding()
                                .padding(.bottom)
                                , alignment: .bottom
                            )
                            .onTapGesture {
                                showPopup = false
                            }
                        }

                        Spacer()
//                    }

                    Button(action: {

                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 21))
                    }

                    Spacer()
                }
                .padding(.top, 13)
                .padding(.bottom, 16)
                .padding(.horizontal, 30)
                .foregroundStyle(.primary.opacity(0.9))
            }
        )
        .animation(.smooth(duration: 0.3), value: showCalendar)
    }

    private var main: some View {
        CenterStack {
            VStack(spacing: 10) {
                Text("Jan".uppercased())
                    .font(.system(size: UIConstants.subhead, weight: .medium, design: .rounded))

                Text("1")
                    .font(.system(size: 69, weight: .black))
            }
        }
        .background(
            FluidGradient(
                blobs: [
                    Color(.systemBackground).opacity(0.1),
                    primaryColor.opacity(colorScheme == .dark ? 0.1 : 0.2),
                    secondaryColor.opacity(colorScheme == .dark ? 0.1 : 0.2),
                    tertiaryColor.opacity(colorScheme == .dark ? 0.1 : 0.2)
                ],
                highlights: [
                    colorScheme == .dark ? .black.opacity(0.1) : .white.opacity(0.1),
                    primaryColor.opacity(colorScheme == .dark ? 0.15 : 0.3),
                    secondaryColor.opacity(colorScheme == .dark ? 0.15 : 0.3),
                    tertiaryColor.opacity(colorScheme == .dark ? 0.15 : 0.3)
                ],
                speed: 0.5,
                blur: 0.7
            )
            .saturation(1.1)
            .contrast(1.3)
            .background(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.3))
            .ignoresSafeArea()
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:
                    UIConstants.screenIsRounded ? UIConstants.screenRadius : UIConstants.screenRadius,
                style: .continuous
            )
        )
        .scaleEffect(showCalendar ? 0.7 : 1)
        .onTapGesture {
            showCalendar = false
        }
        .blur(radius: showPopup ? 5 : 0)
    }


    private var fakeDrag: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { gesture in
                fake = gesture.translation.width
                fake = gesture.translation.height
            }
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { gesture in
                showCalendar = (gesture.translation.width != 0)
            }
    }

}
