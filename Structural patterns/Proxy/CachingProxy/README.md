# 캐싱 프록시

캐싱 프록시는 비용이 많이 드는 작업 결과를 미리 캐시 하여 같은 요청이 있을때 캐시 된 데이터를 전달해 주는 그런 익숙하디 익숙한 로직을 프록시로 빼준 것을 얘기합니다.

이걸 프록시로 해줄 이유 있음..?
이란 의문이 드실 수 있습니다.

뭐 내가 캐싱 로직을 추가하고싶은 객체를 직접 수정해서 바꿔줄 수 있겠죠.
근데 만약 그 객체가 외무 모듈의 객체라면?? 건들이기 조차 두려운 방대한 레거시 코드라면????

답이 없습니다. 저런거 수정해서 사용할 바에는 그냥 프록시 같은 캐싱 전용 레이어를 하나 추가해서 관리하는게 유지보수 측면에서는 훨 편할지 모릅니다.

언제 사용해면 좋을지를 알았으니 바로 코드로도 함 봐보죠.

```Swift
protocol DataFetcher {
    func fetchData() -> String
}

class ExpensiveDataFetcher: DataFetcher {
    func fetchData() -> String {
        // 비용이 많이 드는 데이터 획득 과정 (예: 복잡한 계산, 외부 API 호출 등)
        return "Expensive Data"
    }
}

```

자 프록시 특 뭐다? 프로토콜 똑같이 채택하고 같은 동작에 대해서 약간 변형을 주는 것이죠.
(약간 클래스 상속받아서 오버라이딩 해서 쓴다는 느낌도 들고..?)

암튼 캐싱 프록시 구현하면 아래와 같이 구현할 수 있습니다.

```Swift
class CachingDataFetcherProxy: DataFetcher {           // 👈 이거 프록시 종특
    private let wrappedFetcher: DataFetcher   // 👈 이거 프록시 종특
    private var cache: String?

    init(fetcher: DataFetcher) {
        self.wrappedFetcher = fetcher
    }

    func fetchData() -> String {
        if let cachedData = cache {
            return cachedData
        } else {
            let data = wrappedFetcher.fetchData()
            cache = data
            return data
        }
    }
}
```

자 이렇게 DataFetcher와 같은 함수들을 가지고 있지만 캐싱을 도와주는 더 쩌는 객체(프록시)가 탄생했습니다.
일케 되면 ExpensiveDataFetcher를 직접 사용하지 않고 CachingDataFetcherProxy를 대신 사용하게 되면 캐싱 작업이 추가된 ExpensiveDataFetcher를 ExpensiveDataFetcher객체의 직접적인 수정 없이 가능하게 되는 것이죠.

음청나죠?

이렇게 프록시는 단순 캐싱 뿐만 아니라 기존에 구현되어있는 코드 앞 뒤로 어떤 동작들을 추가해서 꾸며주고싶다 할 때에도 프록시는 유용하게 사용될 수 있습니다.
