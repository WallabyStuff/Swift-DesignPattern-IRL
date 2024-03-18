# Strategy Pattern

이번에는 전략 패턴에 대해서 알아보겠습니다.

전략 패턴은 정말 별거 없습니다. POP(Protocol Oriented Programming)을 지키며 코드를 짜오시던 분들께는 특히 더요.

전략 패턴의 핵심부터 얘기해보자면 자주 변경되는 알고리즘을 protocol로 추상화해서 이를 구현하는 구현체 내에 각기 다른 알고리즘을 캡슐화 한 뒤 런타임에 입맛에 골라서 알고리즘을 사용해라~ 이런 말인데..

이 말도 좀 헷갈리네요. 코드로 보여드리자면 이렇습니다.

기존 코드
```Swift
struct Decoder {
  func decode(data: Data, type: String) {
    if type == "json" {
      // json 디코딩 알고리즘
    } else if type == "xml" {
      // xml 디코딩 알고리즘
    }
  }
}
```

이런 코드를 아래와같이 추상화된 객체에 의존해라~ 이 말입니다.

```Swift
protocol DecodeStrategy { 
  func decode(data: Data) // <- 이렇게 알고리즘을 캡슐화 할 수 있게 추상화
}

struct JsonDecodeStrategy: DecodeStrategy {
  func decode(data: Data) {
    // json 디코딩 알고리즘
  } 
}

struct XMLDecodeStrategy: DecodeStrategy {
  func decode(data: Data) {
    // xml 디코딩 알고리즘
  } 
}

struct Decoder {
  let strategy: DecodeStrategy

  init(strategy: DecodeStrategy) {
    self.strategy = strategy
  }

  func decode(data: Data) {
    strategy.decode(data: data)
  }
}
```

읭?? 걍 추상화 된 객체에 의존한 흔하디 흔한 방식 아냐?

예 맞습니다.

근데 strategy 패턴에서 강조하는 것이 있습니다.

바로 👉알고리즘👈 을 캡슐화 해야한다는 것 입니다.

즉 알고리즘을 캡슐화 하지 않고 다른 어떠한 로직을 추상화된 객체의 구현체로 캡슐화 한다는거는 strategy 패턴이 아니란 소린데..

솔직히 그냥 말장난 같습니다.

아니면 POP가 익숙한 swift 사용자에게 특히 그렇게 느껴지는 것일지도 모르겠네요!

어쨌던 Strategy 패턴은 그냥 이런 사용 양식을 거창하게 Strategy라고 부르는구나.. 정도로 이해해도 괜찮지 않을까요?

</br>

## Wrap up

따라서 전략 패턴의 정의를 정리하자면 다음과 같겠습니다.

> 자주 변경되는 알고리즘을 각각 캡슐화 해서 런타임에 알고리즘을 교체할 수 있게 도와주는 패턴
