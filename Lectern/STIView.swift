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

    @State var primaryColor: Color = .blaze
    @State var secondaryColor: Color = .blaze
    @State var tertiaryColor: Color = .yellow

    @State var showPopup = false
    @State var showCalendar = false
    @State var showCamera = false

    @State private var image = UIImage()

    @State var date: String = "January 1"

    @State var bounced = true

    let timer = Timer.publish(every: 0.9, on: .main, in: .common).autoconnect()

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
                .padding()

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

            ZStack {
                Image(systemName: "figure.arms.open")
                    .font(.system(size: 439))
                    .foregroundStyle(.white.opacity(0.3))

                Image(systemName: "heart.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.red.opacity(0.7))
                    .offset(x: 10, y: -60)
                    .blur(radius: 2)
                    .symbolEffect(.bounce, value: bounced)
                    .onReceive(timer) { _ in
                        bounced.toggle()
                    }

                circle
                    .offset(x: 0, y: 60)

                circle
                    .offset(x: 0, y: -160)

                circle
                    .offset(x: 59, y: 160)

                circle
                    .offset(x: -107, y: -10)
            }
            .padding(.horizontal, 40)

            VStack(spacing: 0) {
                LeadingHStack {
                    Text("What symptoms are you experiencing around your mouth?")
                        .font(.title.weight(.bold))
                }
                .padding(.trailing)

                ScrollView {
                    VStack(spacing: 5) {
                        Group {
                            TrailingHStack {
                                Text("Sores")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                            .padding(.vertical, 9)
                            .padding(.horizontal, 13)
                            .background(.white.opacity(0.15))
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                            
                            TrailingHStack {
                                Text("Rashes")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                            .padding(.vertical, 9)
                            .padding(.horizontal, 13)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                            TrailingHStack {
                                Text("Itching")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                            }
                            .padding(.leading)
                            .padding(.vertical, 9)
                            .padding(.horizontal, 13)
                            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))

                            Bar(color: .white.opacity(0.3))
                                .padding(.vertical)
                            
                            TrailingHStack {
                                Text("Describe any symptoms not listed above. For example, pus leakage, bleeding.")
                                    .font(.title2.weight(.bold))
                                    .multilineTextAlignment(.trailing)
                                    .opacity(0.5 )
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
            .padding(.horizontal, 24)
            .padding()
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
            .saturation(1.3)
            .contrast(1.3)
            .background(Color.white.opacity(colorScheme == .dark ? 0.3 : 0.7))
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

    private var circle: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 30, height: 30)
            .background(Blur(.systemUltraThinMaterialLight))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 3)
            )
    }
}
