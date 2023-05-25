//
//  ChartView.swift
//  Crypto-Tracker-iOS
//
//  Created by Harsh Kumar Agrawal on 17/05/23.
//

import SwiftUI
import Combine
import UIKit
import Foundation

struct ChartView: View {
    
    private let data: [Double]
    private let maxValue: Double
    private let minValue: Double
    private var lineColor: Color
    private var startDate: Date
    private var endDate: Date
    @State private var percentage: CGFloat = 0
    
    init(_ coin: Coin) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxValue = data.max() ?? 0
        self.minValue = data.min() ?? 0
        
        let priceChange = (data.last ?? 0)  - (data.first ?? 0)
        lineColor = priceChange > 0 ? .green : .red
        endDate = coin.lastUpdated?.toDate() ?? Date()
        startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
    }
    
    var body: some View {

        VStack {
            Text("Dollars $")
                .frame(maxWidth: .infinity, alignment: .leading)
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .padding(.leading, 45)
                .padding(.trailing, 10)
                .overlay(chartYAxis, alignment: .leading)
            
            chartXAxis
        }
        .padding(2)
        .font(.caption)
        .foregroundColor(Color(UIColor.whiteGray))
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.linear(duration: 3.0)) {
                    percentage = 1.0
                }
            }
        }
    }
}

extension ChartView {
    
    private var chartView: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let width = geometry.size.width
                
            let step = width / CGFloat(data.count - 1)
            
            let points = data.enumerated().map { index, value in
                CGPoint(x: CGFloat(index) * step, y: height - CGFloat(value - minValue) / CGFloat(maxValue-minValue) * height)
                
            }
                    
            Path { path in
                path.addLines(points)
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(1), radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        }
    }
    
    private var chartBackground: some View {
        VStack{
            Divider().background(Color( UIColor.whiteGray))
            Spacer()
            Divider().background(Color( UIColor.whiteGray))
            Spacer()
            Divider().background(Color( UIColor.whiteGray))
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxValue.convertToShortString())
            Spacer()
            Text(((maxValue + minValue)/2).convertToShortString())
            Spacer()
            Text(minValue.convertToShortString())
        }.foregroundColor(Color( UIColor.whiteGray))
    }
    
    private var chartXAxis: some View {
        HStack {
            Text(startDate.toDayMonthString()).padding(.leading, 30)
            Spacer()
            Text(endDate.toDayMonthString()).padding(.trailing, 4)
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(dev.coin)
    }
}
