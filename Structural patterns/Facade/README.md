# Facade

Facade 패턴은 복잡한 시스템을 간단한 인터페이스로 제공해주는 패턴 입니다.

</br>

[Refactoring Guru](https://refactoring.guru/ko/design-patterns/facade)에서 소개된 훌륭한 예시를 참조해 보겠습니다.

여러분이 고객 서비스 센터에 전화를 걸어 "요금제 변경해주세요!"와 같은 요청을 한다고 합니다.
이 때, 상담원은 여러분의 요청을 처리하기 위해 다양한 사내 시스템을 사용하여 사용자 정보를 조회, 요금제 정보를 확인하고, 새로운 요금제로 변경하는 등 여러 단계의 작업을 수행합니다.

![example](facade_example_image.png)

그러나 이러한 복잡한 과정은 클라이언트 측에서 알거나 이해할 필요가 없죠?

 Facade 패턴은 이와 같은 복잡한 작업을 "요금제 변경"이라는 단일 작업으로 추상화하여, 클라이언트가 간단한 명령으로 복잡한 시스템의 결과를 얻을 수 있도록 해줍니다. 마치 고객이 상담원에게 단순한 요청을 통해 여러 복잡한 내부 과정을 거치지 않고도 원하는 결과를 얻는 것과 같이 말이죠!

말이 거창해져서 그런데 그냥 복잡한 구조를 사용하기 쉬운 API로 제공하는 것을 퍼사드라도 이해하셔도 무방합니다.

</br>

## IRL (In Real Life)

> 뭔가 예제 프로젝트를 만들어서 하기에는 Facade패턴이 너무 단순해서 코드 스니펫으로 대체하겠습니다.

예를들어 AuthenticationService, CacheService, NetworkService 등 다양하게 존재한다고 해보겠습니다.

그래서 네트워크 요청을 할 때

1. 사용자 인증 정보를 AuthenticationService를 통해서 확인하고
2. CacheService를 이용해서 캐싱된 정보가 있는지 확인하고 없다면
3. 최종적으로 NetworkService를 통해서 데이터를 요청한다고 가정해 볼게요.

여기서 문제가 뭐냐? 만약 ViewModel 같은 곳에서 매번 네트워크 요청할 때마다 이런 작업을 항상 반복하기에는 조금 무리가 있어보이죠? 로직이 조금 변경되면 구현한 곳 일일이 찾아서 변경도 해줘야하구요..

건강한 개발자라면 이런 반복되는 로직을 어딘가에 빼서 사용할 생각을 할겁니다.

이렇게 다양한 API 호출과 그에 따른 복잡한 처리 로직이 존재할 때, Facade 패턴은 이를 캡슐화하여 클라이언트 코드가 단일 API 호출을 통해 필요한 작업을 수행할 수 있도록 해줍니다.

아마 여러분들도 알게모르게 자주 사용하시던 기법일 겁니다.
그냥 많은 개발자들이 비슷하게 사용하다보니 하나의 패턴이 발견된 것이고 거기에 거창한 이름이 붙었을 뿐.

```Swift

import Foundation

class AuthenticationService {
  func isAuthenticated() -> Bool {
    // 사용자 인증 상태 확인 로직
    return true
  }
}

class CacheService {
  func fetchData(forKey key: String) -> Data? {
    // 캐시에서 데이터 조회 로직
    return nil
  }
  
  func cacheData(_ data: Data, forKey key: String) {
    // 데이터 캐싱 로직
  }
}

class NetworkService {
  func performRequest(to url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    // 실제 네트워크 요청 실행 로직
  }
}

// MARK: - Error

enum NetworkFacadeError: Error {
  case authenticationFailed
  case invalidURL
  case noData
  case cachedDataUnavailable
  case underlyingError(Error)
}


// MARK: - Facade

class NetworkServiceFacade {
  static let authenticationService = AuthenticationService()
  static let cacheService = CacheService()
  static let networkService = NetworkService()
  
  static func fetchData(from urlString: String, useCache: Bool = true, completion: @escaping (Result<Data, Error>) -> Void) {
    guard let url = URL(string: urlString) else {
      completion(.failure(NetworkFacadeError.invalidURL))
      return
    }
    
    guard authenticationService.isAuthenticated() else {
      completion(.failure(NetworkFacadeError.authenticationFailed))
      return
    }
    
    if useCache, let cachedData = cacheService.fetchData(forKey: urlString) {
      completion(.success(cachedData))
      return
    }
    
    networkService.performRequest(to: url) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let data):
          cacheService.cacheData(data, forKey: urlString)
          completion(.success(data))
        case .failure(let error):
          completion(.failure(NetworkFacadeError.underlyingError(error)))
        }
      }
    }
  }
}


// MARK: - Facade 사용하는 곳

NetworkServiceFacade.fetchData(from: "https://api.example.com/data") { result in
  switch result {
  case .success(let data):
    // 데이터 처리
    print("Data fetched successfully.")
  case .failure(let error):
    // 에러 처리
    print("Failed to fetch data:", error)
  }
}

```

보셨다시피 그리 대단한 건 아니고 그냥 저렇게 복잡한 로직을 다른 개발자(클라이언트)가 직접 작성하게 할 필요없이
"이 함수 호출하면 알아서 너가 만드려는거 다 되니까 이거 가져가 써~~ "
뭐 이런 느낌이지 않나 싶습니다.

</br>

이렇게 시스템이 고도화됨에 따라 로직의 복잡성이 증가하는 것은 피할 수 없는 현상인데요. 이러한 복잡성을 관리하기 위해, 특정 부분을 적절히 추상화하거나 다른 객체로 은닉함으로써 클라이언트(개발자)가 보다 고차원적인 함수들을 이용할 수 있게 됩니다.

이 과정에서 Facade 패턴이 복잡한 시스템의 내부 작업을 숨기고, 간단한 인터페이스를 제공함으로써 큰 도움을 주지 않나 생각합니다 =)
