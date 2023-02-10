//
//  WeatherView.swift
//  WeatherApp
//
//  Created by John Reichel on 2/9/23.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    @State var show = false
    @State var celcius = false
    @State var degreeUnit = "Fahrenheit"
    @Namespace var namespace
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    HStack {
                        Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                            .fontWeight(.light)
                        Spacer()
                        Text(degreeUnit)
                            .fontWeight(.light)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: conditionImage())
                                .font(.system(size: 40))
                            
                            Text(weather.weather[0].main)
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Button {
                            celcius.toggle()
                            if !celcius {
                                degreeUnit = "Fahrenheit"
                            } else {
                                degreeUnit = "Celcius"
                            }
                        } label: {
                            if !celcius {
                                Text(weather.main.feels_like.roundDouble() + "°")
                                    .font(.system(size: 80))
                                    .fontWeight(.bold)
                            } else {
                                Text(toCelcius())
                                    .font(.system(size: 80))
                                    .fontWeight(.bold)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 80)
                    
                    AsyncImage(url: URL(string: "https://cdn.pixabay.com/photo/2020/01/24/21/33/city-4791269_960_720.png")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 350)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                if !show {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Current Weather")
                            .bold().padding(.bottom)
                            .matchedGeometryEffect(id: "text", in: namespace)
                            
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "min_temp", in: namespace)
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "max_temp", in: namespace)
                        }
                        HStack {
                            WeatherRow(logo: conditionImage(), name: "Feels like", value: (weather.main.feels_like.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "feels_like", in: namespace)
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                                .matchedGeometryEffect(id: "humidity", in: namespace)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom)
                    .foregroundColor(Color(hue: 0.571, saturation: 0.561, brightness: 0.967))
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "currentWeather", in: namespace)
                    )
                } else {
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("Current Weather")
                            .bold().padding(.bottom)
                            .matchedGeometryEffect(id: "text", in: namespace)
                            
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "min_temp", in: namespace)
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "max_temp", in: namespace)
                        }
                        HStack {
                            WeatherRow(logo: conditionImage(), name: "Feel like", value: (weather.main.feels_like.roundDouble() + "°"))
                                .matchedGeometryEffect(id: "feels_like", in: namespace)
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                                .matchedGeometryEffect(id: "humidity", in: namespace)
                        }
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + "m/s"))
                                .matchedGeometryEffect(id: "wind", in: namespace)
                            Spacer()
                        }
                    }
                    .frame(height: 550, alignment: .top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundColor(Color(hue: 0.571, saturation: 0.561, brightness: 0.967))
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "currentWeather", in: namespace)
                    )
                }
            }
            .onTapGesture {
                show.toggle()
            }
        }
        .foregroundColor(.white)
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.571, saturation: 0.561, brightness: 0.967))
    }
    
    func conditionImage() -> String {
        switch weather.weather[0].main {
        case "Thunderstorm":
            return "cloud.bolt"
        case "Drizzle":
            return "cloud.drizzle"
        case "Rain":
            return "cloud.rain"
        case "Snow":
            return "cloud.snow"
        case "Atmosphere":
            return "cloud.sun"
        case "Clear":
            return "sun.max"
        case "Clouds":
            return "cloud"
        default:
            return "cloud.sun"
        }
    }
    
    func toCelcius() -> String {
        return String(Double(weather.main.feels_like - 32 / 1.8).roundDouble()) + "°"
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
