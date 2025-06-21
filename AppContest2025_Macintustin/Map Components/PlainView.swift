/**
 @file PlainView.swift
 @project AppContest2025_Macintustin
 
 @brief A SwiftUI view providing map search, selection, and navigation functionality.
 @details
  PlainView is a comprehensive map interface built with SwiftUI and MapKit that enables users
  to search for locations, view search results on the map, select destinations, and obtain
  walking directions. It includes:

  - LocationManager: A helper class for requesting and updating the user's current location.
  - A search bar allowing natural language queries for nearby places.
  - Dynamic rendering of search results as map markers with color coding.
  - Displaying route overlays when navigation is active.
  - Integration with LocationDetailsView to show detailed information about selected locations.
  - Support for starting and cancelling navigation with animated transitions.
  - Intelligent map region adjustment to fit user and destination coordinates.
  - Handling user interactions such as dismissing keyboard on map taps and clearing search text.

 This view manages a variety of state variables including map position, search results,
 selected destination, routing information, and navigation status, while ensuring
 smooth UI updates and user experience.
 
 @author 赵禹惟
 @date 2025/4/16
 */

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
                            .foregroundStyle(.blue.opacity(0.25))
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.white)
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(.blue)
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
                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                        .shadow(radius: 10)
                        .padding()
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.9)
                        .submitLabel(.search)
                                                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.black)
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
        let userLocationCL = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let destinationLocationCL = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        
        let eastWestDistance = abs(userLocationCL.coordinate.longitude - destinationLocationCL.coordinate.longitude) * 111_000 * cos(userLocation.latitude * .pi / 180)
        let northSouthDistance = abs(userLocationCL.coordinate.latitude - destinationLocationCL.coordinate.latitude) * 111_000
        
        let maxDistance = max(eastWestDistance, northSouthDistance)
        
        let paddingFactor: Double = 1.5
        let latitudeDelta = max(0.01, (maxDistance * paddingFactor) / 111_000)
        let longitudeDelta = max(0.01, (maxDistance * paddingFactor) / (111_000 * cos(userLocation.latitude * .pi / 180)))
        
        let centerLatitude = (userLocation.latitude + destinationCoordinate.latitude) / 2
        let centerLongitude = (userLocation.longitude + destinationCoordinate.longitude) / 2
        let centerCoordinate = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        
        let region = MKCoordinateRegion(
            center: centerCoordinate,
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
        
        DispatchQueue.main.async {
            self.position = .region(region)
        }
    }
}
