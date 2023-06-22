//
//  STIView.swift
//  Lectern
//
//  Created by Paul Wong on 6/20/23.
//

import SwiftUI
import UIKit
import FluidGradient

struct STIView: View {

    @Environment(\.colorScheme) var colorScheme

    @State var fake: CGFloat = 0.0

    @State var primaryColor: Color = .blue
    @State var secondaryColor: Color = .cyan
    @State var tertiaryColor: Color = .mint

    @State var showPopup = false
    @State var showCalendar = false
    @State var showCamera = false

    @State private var image = UIImage()

    @State var date: String = "January 1"

    var body: some View {
        TabView {
            ForEach(0..<11, id: \.self) { _ in
                main
                    .simultaneousGesture(showCalendar ? nil : drag)
                    .ignoresSafeArea()
            }
        }
        .tabViewStyle(.page(indexDisplayMode: showCalendar ? .always : .never))
        .ignoresSafeArea(showCalendar ? .keyboard : .all)
        .background(Color.black.ignoresSafeArea())
        .overlay(
            VStack(spacing: 0) {
                CenterHStack {
                    TextField(
                        "January 1",
                        text: $date
                    )
                    .font(.system(size: UIConstants.callout).weight(.semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.horizontal)
                    .submitLabel(.done)
                }
                .padding(.vertical)
                .padding(.horizontal, 30)

                Spacer()
            }
            , alignment: .top
        )
    }

    private var main: some View {
        HStack(spacing: 0) {
            VStack(spacing: 16) {
                Spacer()

                Button(action: {
                    withAnimation(.smooth) {
                        showPopup = true
                    }
                }) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 21))
                        .frame(width: 24, height: 24)
                        .padding(11)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
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

                Button(action: {
                    withAnimation(.smooth) {
                        showCamera = true
                    }
                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 21))
                        .frame(width: 24, height: 24)
                        .padding(11)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
                }
                .fullScreenCover(isPresented: $showCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: self.$image)
                        .background(Color.black.ignoresSafeArea())
                }

                Button(action: {

                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 21))
                        .frame(width: 24, height: 24)
                        .padding(11)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
                }

                Button(action: {

                }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 21))
                        .frame(width: 24, height: 24)
                        .padding(11)
                        .background(.white.opacity(0.15))
                        .clipShape(Circle())
                }

                Spacer()
            }
            .padding(.leading)
            .foregroundStyle(.white.opacity(0.9))
            .opacity(showCalendar ? 0 : 1)

            VStack(spacing: 0) {
                LeadingHStack {
                    Text("Do you have a fever or other flu-like symptoms?")
                        .font(.title.weight(.bold))
                }
                .padding(.trailing)

                ScrollView {
                    VStack(spacing: 5) {
                        Group {
                            TrailingHStack {
                                Text("Yes")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                            .padding(13)
                            .background(.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            
                            TrailingHStack {
                                Text("No")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                            .padding(13)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            
                            Bar()
                                .padding(.vertical)
                            
                            TrailingHStack {
                                Text("Anything else to add?")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                        }
                        .scrollTransition(axis: .vertical) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.7)
                                .blur(radius: phase.isIdentity ? 0 : 5)
                        }
                    }
                    .padding(.top)
                }
                .safeAreaPadding(.vertical)
                .mask(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .black, location: 0.05)
                ]), startPoint: .top, endPoint: .bottom))
            }
            .foregroundStyle(.white)
            .padding(.top, 120)
            .padding(.vertical)
            .padding(.horizontal, 30)
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
            .background(Color.white.opacity(colorScheme == .dark ? 0.1 : 0.7))
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
            withAnimation(.smooth(duration: 0.3)) {
                showCalendar = false
            }
        }
        .blur(radius: showPopup ? 5 : 0)
        .animation(.smooth(duration: 0.3), value: showCalendar)
    }

    private var drag: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged { gesture in
                if gesture.translation.width < -20 || gesture.translation.width > 20 {
                    withAnimation(.smooth(duration: 0.3)) {
                        showCalendar = true
                    }
                }
            }
    }
}
