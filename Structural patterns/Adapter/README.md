# Adapter

Adapter 패턴은 서로다른 인터페이스를 가진 클래스들을 연결해서 함께 작동하도록 만드는 구조적 패턴 입니다.
음.. 정의만으로는 이해가 잘 되지 않으니 코드랑 함께 보시죠.

</br>

## IRL (In Real Life)

예를들어 다음과 같이 기존에 사용하던 NaverMap의 카메라이동, 마커추가 로직이 있다고 해보겠습니다.

```Swift
// 네이버맵 카메라 이동 로직
let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 9)
cameraUpdate.animation = .easeIn
mapView.moveCamera(cameraUpdate)

// 네이버맵 마커 추가 로직
let marker = NMFMarker()
marker.position = NMGLatLng(lat: lat, lng: lng)
marker.mapView = mapView

```

아니근데 서비스 확장을 위해서 일부 지역에서는 네이버 지도가 아닌 애플지도를 사용해야한다는 기획이 떨어졌습니다!!
뭐 어쩌겠습니까! 까라면 까아죠!!

그렇게 애플맵에서도 같은 기능인 moveCamera 그리고 마커추가 로직에 대응을 해주려는데 네이버맵과는 사용 방식이 약간 다른겁니다..

```Swift
// 애플맵 카메라 이동 로직
let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                     latitudinalMeters: 1000, longitudinalMeters: 1000)
mapView.setRegion(region, animated: true)

// 애플맵 마커 추가 로직
let annotation = MKPointAnnotation()
annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
annotation.title = "부산"
annotation.subtitle = "떠나자 부산으로!"

mapView.addAnnotation(annotation)

```

아.. 곤란합니다.
그럼 카메라 이동로직, 마커추가 로직에 대해서 맵 종류에 따라서 분기 따줄까요?

```Swift
switch mapType {
case .naver:
 let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 9)
 cameraUpdate.animation = .easeIn
 mapView.moveCamera(cameraUpdate)
case .apple:
 let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
        latitudinalMeters: 1000, longitudinalMeters: 1000)
 mapView.setRegion(region, animated: true)
}
```

흠.. 이렇게 하면 새로운 지도 서비스를 추가하거나 기존 서비스의 API가 변경되면 이 함수를 직접 수정해야하면서 OCP에 위배가 되겠군요.. 그리고 그럼 이렇게 일일이 각 서비스 API에 맞게 분기쳐줘야 한단 말이야??
라는 퇴사 마려운 생각이 들게 됩니다.

하지만 어림도 없습니다.
우리에겐 Adapter 패턴이 있으니까요!

자 차근차근 Adapter 패턴을 이용해서 우리가 수정할 수 없는 외부 라이브러리들의 코드들을 기존에 우리가 사용하던 방식대로 호환 되게 만들어 보자구요!

그러기 위해선 일단 기존에 사용하던 방식을 추상화 시켜줘야 합니다.! **(중요!! 추상화를 안 하면 어댑터를 사용할 수 없음)**

```Swift
protocol MapService {
  func moveCamera(lat: Double, lng: Double)
  func addMarker(lat: Double, lng: Double)
}

```

그럼 기존의 NaverMap은 이 프로토콜을 채택해서 아래와 같이 구현할 수 있겠죠?

```Swift
import NMapsMap

final class NaverMapAdapter: MapService {
  
  private let mapView = NMFMapView()
  
  func moveCamera(lat: Double, lng: Double) {
    let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 9)
    cameraUpdate.animation = .easeIn
    mapView.moveCamera(cameraUpdate)
  }
  
  func addMarker(lat: Double, lng: Double) {
    let marker = NMFMarker()
    marker.position = NMGLatLng(lat: lat, lng: lng)
    marker.mapView = mapView
  }
}


```

추상화 된 걸로 한 번 감싸주는 거라고 생각해주면 됩니다.

그럼 기획 요청에 따라 애플맵을 추가해보겠습니다.
애플맵에 구현되어있는 함수들은 조금 다르긴 하지만 MapService의 함수들을 구현할 때 최대한 기존 동작 방식과 비슷하게만 로직을 작성해주면 되는 문제 아니겠습니까!

```Swift
import MapKit

final class AppleMapAdapter: MapService {
  
  private let mapView = MKMapView()
  
  func draw(in viewController: UIViewController) {
    viewController.view.addSubview(mapView)
    mapView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func moveCamera(lat: Double, lng: Double) {
    let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                                    latitudinalMeters: 1000, longitudinalMeters: 1000)
    mapView.setRegion(region, animated: true)
  }

  func addMarker(lat: Double, lng: Double) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    annotation.title = "부산"
    annotation.subtitle = "떠나자 부산으로!"

    mapView.addAnnotation(annotation)
  }
}


```

자 보시면 네이버 지도에서의 사용하는 moveCamera와 가장 비슷한 동작을 하는 애플맵에서의 setRegion을 호출해서 adapting 해주는 모습을 볼 수 있습니다. 마커 추가해주는 쪽도 마찬가지로요!

이렇게 기존에 사용하던 객체를 추상화 해서 어댑터로 기존에 동작하던 로직과 비슷하게 구현해주면 유연하게 객체를 추가할 수 있겠죠??
(만약 새로운 카카오맵을 추가한다고 하면 MapService 프로토콜을 채택한 객체만 새로 만들어주면 되니까 말이죠!)
어떻게 보면 각 기능들을 추상화 해서 거기에 wrapping 해준다고도 생각할 수 있을것 같습니다.

기존에 사용하던 객체를 추상화 해서 다른 객체도 추상화의 구현을 통해 비슷한 동작을 하도록 wrapping 해주는 방식, 이게 어댑터 패턴입니다.
간단하죠?
