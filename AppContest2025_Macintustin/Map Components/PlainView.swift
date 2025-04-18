//
//  PlainView.swift
//  AppContest2025_Macintustin
//
//  Created by 赵禹惟 on 2025/4/16.
//

import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?

    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location.coordinate
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

struct PlainView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var searchText = ""
    @State private var results = [MKMapItem]()
    @State private var previousmapSelection: MKMapItem? = nil
    @State private var mapSelection: MKMapItem?
    @State private var showDetails = false
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var isNavigating = false
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position, selection: $mapSelection) {
                UserAnnotation() {
                    ZStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.blue.opacity(0.25))
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.blue)
                    }
                }
                
                ForEach(results, id: \.self) { item in
                    let placemark = item.placemark
                    Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                        .tint(markerColor(for: placemark))
                }
                
                if let route {
                    MapPolyline(route.polyline)
                        .stroke(.blue, lineWidth: 6)
                }
            }
            .onTapGesture {
                back2Map()
            }
            .mapControls {
                MapCompass()
                MapUserLocationButton()
            }
            .ignoresSafeArea(.keyboard)
            .onAppear {
                locationManager.requestLocation()
            }
            
            GeometryReader { geometry in
                ZStack {
                    TextField("Search for a location...", text: $searchText)
                        .font(.subheadline)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(colorScheme == .dark ? Color.gray.opacity(0.8) : Color.white.opacity(0.8))
                        )
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .shadow(radius: 10)
                        .padding()
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.9)
                        .submitLabel(.search)
                                                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.black)
                                .padding(.trailing)
                        }
                        .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.9)
                    }
                }
            }
            .background(Color.clear)
            .zIndex(1)
        }
        .onSubmit(of: .text) {
            Task { await searchPlaces() }
        }
        .onChange(of: getDirections, { oldValue, newValue in
            if newValue {
                fetchRoute()
            }
        })
        .onChange(of: mapSelection, { oldValue, newValue in
            if let newValue {
                if newValue == previousmapSelection {
                    showDetails = true
                } else {
                    previousmapSelection = newValue
                    showDetails = true
                }
            }
        })
        .sheet(isPresented: $showDetails, content: {
            LocationDetailsView(
                mapSelection: $mapSelection,
                show: $showDetails,
                getDirections: $getDirections,
                routeDisplaying: $routeDisplaying,
                route: $route,
                cancelNavigation: cancelNavigation
            )
            .presentationDetents([.height(365)])
            .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
            .presentationCornerRadius(12)
        })
    }
}

extension PlainView {
    func back2Map() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func searchPlaces() async {
        guard let userLocation = locationManager.currentLocation else {
            print("User location not available")
            return
        }
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = MKCoordinateRegion(
            center: userLocation,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        
        let results = try? await MKLocalSearch(request: request).start()
        self.results = results?.mapItems ?? []
        
        if let firstResult = results?.mapItems.first {
            let destinationCoordinate = firstResult.placemark.coordinate
            adjustMapRegion(userLocation: userLocation, destinationCoordinate: destinationCoordinate)
        }
    }
    
    func fetchRoute() {
        guard let mapSelection = mapSelection,
              let userLocation = locationManager.currentLocation else {
            print("User location not available")
            return
        }
        
        routeDestination = mapSelection
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation))
        request.destination = mapSelection
        request.transportType = .walking
        
        isNavigating = true
            
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
                        
            withAnimation(.snappy) {
                routeDisplaying = true
                showDetails = false
                            
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    position = .rect(rect)
                }
            }
        }
    }
    
    func cancelNavigation() {
        withAnimation(.snappy) {
            isNavigating = false
            routeDisplaying = false
            route = nil
            routeDestination = nil
            getDirections = false
            
            results = []
            
            if locationManager.currentLocation != nil {
                position = .userLocation(fallback: .automatic)
            }
        }
    }
    
    func markerColor(for placemark: MKPlacemark) -> Color {
        guard let routeDestination = routeDestination else {
            return .blue
        }
        return (placemark.coordinate.latitude == routeDestination.placemark.coordinate.latitude &&
                placemark.coordinate.longitude == routeDestination.placemark.coordinate.longitude) ? .green : .blue
    }
    
    func adjustMapRegion(userLocation: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let userPoint = MKMapPoint(userLocation)
        let destinationPoint = MKMapPoint(destinationCoordinate)
        
        let mapRect = MKMapRect(
            x: min(userPoint.x, destinationPoint.x),
            y: min(userPoint.y, destinationPoint.y),
            width: abs(userPoint.x - destinationPoint.x),
            height: abs(userPoint.y - destinationPoint.y)
        )
        
        let paddingValue = max(50, mapRect.height * 0.3)
        let padding = UIEdgeInsets(
            top: paddingValue,
            left: paddingValue * 0.5,
            bottom: paddingValue,
            right: paddingValue * 0.5
        )
        
        let adjustRect = mapRect.insetBy(
            dx: -padding.left - padding.right,
            dy: -padding.top - padding.bottom
        )
        
        DispatchQueue.main.async {
            self.position = .rect(adjustRect)
        }
    }
}
