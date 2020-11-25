//
//  ConditionsView.swift
//  conditions-swiftui
//
//  Created by Noah Scholfield on 9/5/20.
//

import SwiftUI

struct ConditionsView: View {
    @ObservedObject var data: FetchConditions
    
    init() {
        data = FetchConditions()
        let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = UIColor(Color("AccentColor"))
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
           UINavigationBar.appearance().barTintColor = .purple
           UINavigationBar.appearance().isTranslucent = false
           UINavigationBar.appearance().standardAppearance = appearance
           UINavigationBar.appearance().compactAppearance = appearance
           UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        let sun = data.conditions.sun
        let moon = data.conditions.moon
        let weather = data.conditions.conditions
        
        NavigationView {
            ScrollView {
                LocationInput()
                WeatherView(weather: weather.observation[0])
                SunView(sun: sun.results)
                MoonView(moon: moon.astronomy)
                Spacer()
            }
            .navigationBarTitle("Conditions", displayMode: .large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        ConditionsView()
    }
}

struct LocationInput: View {
    @State private var location: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Enter a location")
            TextField("Pittsburgh, PA", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding([.horizontal, .top])
    }
}

struct SunView: View {
    var sun: SunData
    
    var body: some View {
        VStack {
            Text("Sun")
                .font(.title)
                .foregroundColor(.white)
                .padding(.top)
            HStack() {
                VStack {
                    Image(systemName: "sunrise.fill")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 40.0, height: 42.0)
                        .foregroundColor(.yellow)
                    Text("\(sun.sunrise, style: .time)")
                        .font(.title2)
                        .foregroundColor(.white)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                Spacer()
                VStack {
                    Image(systemName: "sunset.fill")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 45.0, height: 42.0)
                        .foregroundColor(.orange)
                    Text("\(sun.sunset, style: .time)")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                Spacer()
                VStack {
                    Image(systemName: "building.fill")
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 22.0, height: 42.0)
                        .foregroundColor(.gray)
                    Text("\(sun.civil_twilight_end, style: .time)")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.all)
        }.background(Color("Green"))
        .cornerRadius(25)
        .padding(.all)
    }
}

struct MoonView: View {
    var moon: [MoonData]
    
    var body: some View {
        NavigationLink(destination: MoonExpandedView(moonData: moon)) {
            VStack {
                Text("Moon")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                MoonDetailsView(moon: moon[0])
                    .padding(.bottom)
            }
            .background(Color("LightBlue"))
            .cornerRadius(25)
            .padding(.all)
        }
    }
}

struct MoonDetailsView: View {
    var moon: MoonData
    
    var body: some View {
        HStack() {
            VStack {
                Image(systemName: "moon.fill")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 35.0, height: 42.0)
                    .foregroundColor(.yellow)
                    .padding(.bottom)
                Text("\(moon.moonrise)")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            Spacer()
            VStack {
                Image(systemName: "moon.zzz.fill")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width: 35.0, height: 42.0)
                    .foregroundColor(.orange)
                    .padding(.bottom)
                Text("\(moon.moonset)")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            Spacer()
            VStack {
                Text(moon.moonPhasePercent)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding(.vertical)
                Text(moon.moonPhaseDesc)
                    .foregroundColor(.white)
            }
            .frame(minWidth: 0, maxWidth: .infinity)
        }
    }
}

struct MoonExpandedView: View {
    var moonData: [MoonData]
    
    var body: some View {
        VStack() {
            List(moonData) { day in
                VStack {
                    Text(day.date, style: .date)
                    MoonDetailsView(moon: day)
                }
                .padding(.all)
                .background(Color("LightBlue"))
                .cornerRadius(25)
            }
        }
        .navigationBarTitle("Moon Forecast", displayMode: .inline)
    }
}

struct WeatherView: View {
    var weather: WeatherData
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Image(systemName: "thermometer")
                        Text("\(weather.temperature.components(separatedBy: ".")[0])º")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                    Text(weather.skyDescription)
                        .font(.title2)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                Spacer()
                VStack {
                    HStack {
                        Image(systemName: "cloud.rain.fill")
                        Text(weather.precipitation)
                            .font(.largeTitle)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    Text("inches")
                        .font(.title2)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.vertical)
            Divider()
                .frame(height: 1)
                .background(Color.white)
                .padding(.horizontal)
            Text(weather.description)
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding(.vertical)
        }
        .foregroundColor(.white)
        .background(Color.red)
        .cornerRadius(25)
        .padding(.all)
    }
}
