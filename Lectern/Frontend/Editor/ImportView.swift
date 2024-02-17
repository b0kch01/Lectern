//
//  ImportView.swift
//  Lectern
//
//  Created by Paul Wong on 2/16/24.
//

import SwiftUI

struct ImportView: View {

    @Environment(\.safeAreaInsets) var safeAreaInsets

    @Environment(ContentManager.self) var cm
    @Environment(EditorViewModel.self) var vm
    @Environment(NavigationViewModel.self) var nvm

    var body: some View {
        VStack(spacing: 20) {
            Group {
                if !vm.showScan {
                    filesQueue
                        .transition(.scale)
                }
            }
            .opacity(vm.showScan ? 0 : 1)
            .blur(radius: vm.showScan ? 10 : 0)

            Group {
                if vm.showScan {
                    scansQueue
                        .transition(.scale)
                }
            }
            .opacity(!vm.showScan ? 0 : 1)
            .blur(radius: !vm.showScan ? 10 : 0)
        }
        .ignoresSafeArea()
        .padding(.horizontal)
        .foregroundColor(.white)
        .background(.black)
        .overlay(
            NoteSafeAreaBlock()
            , alignment: .top
        )
        .overlay(
            HStack(spacing: 0) {
                Text("Import Notes & Documents")
                    .font(Font.custom("OpenRunde-Semibold", size: 16))

                Spacer()

                Image(systemName: "xmark")
                    .font(.body.weight(.semibold))
                    .padding(5)
            }
            .padding()
            .padding(.top, safeAreaInsets.top)
            , alignment: .top
        )
        .overlay(
            ImportControl()
            , alignment: .bottom
        )
        .ignoresSafeArea()
    }

    var filesQueue: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Queued Files")
                        .font(Font.custom("OpenRunde-Regular", size: 14))
                        .foregroundStyle(.secondary)

                    Spacer()
                }

                VStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: 13) {
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(.white.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .stroke(.white.opacity(0.15), lineWidth: 1)
                                )
                                .frame(width: 39, height: 39)

                            VStack(alignment: .leading, spacing: 3) {
                                Text("SampleNote.pdf")
                                    .font(Font.custom("OpenRunde-Medium", size: 15))
                            }

                            Spacer()
                        }
                    }
                }
            }
            .padding(.top, safeAreaInsets.top + 60)
            .padding(.bottom, safeAreaInsets.bottom)
            .padding(.vertical)
        }
    }

    var scansQueue: some View {
        ScrollView {
            VStack(spacing: 20) {
                HStack {
                    Text("Queue Scans")
                        .font(Font.custom("OpenRunde-Regular", size: 14))
                        .foregroundStyle(.secondary)

                    Spacer()
                }

                VStack(spacing: 10) {
                    ForEach(1...2, id: \.self) { number in
                        let imageName = String(format: "2006_CBR600RR 2-%03d", number)
                        Image(imageName).resizable()
                            .aspectRatio(contentMode: .fill)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke(.borderBackground, lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.05), radius: 1, y: 1)
                            .shadow(color: Color.black.opacity(0.1), radius: 10)
                    }

                    Spacer()
                }
            }
            .padding(.top, safeAreaInsets.top + 60)
            .padding(.bottom, safeAreaInsets.bottom)
            .padding(.vertical)
        }
    }
}
