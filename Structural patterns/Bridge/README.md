# Bridge

Bridge 패턴은 구현을 추상화로 분리하고 그 구현을 가져다 사용하는것을 얘기합니다.
역시 정의만으로는 와닿지 않네요..

Bridge 패턴을 사용하지 않았을 때와 사용했을 때를 비교해가면 설명해보겠습니다.

</br>

## IRL (In Real Life)

### Bridge 패턴을 사용하지 않았을 때

아래와같이 결제를 처리하는 클래스를 만들어보았다고 해보겠습니다.

```Swift
class PaymentProcessor {
  private let amount: Double
  
  init(amount: Double) {
    self.amount = amount
  }
  
  func payWithCreditCard() {
    // 신용카드 결제 로직
  }
  
  func payWithToss() {
    // 토스페이 결제 로직
  }
  
  func payWithNaverPay() {
    // 네이버페이 결제 로직
  }
}
```

뭐 사용하는 데에 크게 문제는 없어보입니다...만!!
브릿지패턴 입장에서 보면 다음과 같은 문제들이 있을 수 있겠습니다.

- payWithCreditCard, payWithToss, payWithNaverPay 로직이 PaymentProcess 라는 클래스에 강하게 결합되어있습니다.
- 또 새로운 메세지 전송방식을 추가하려면 PaymentProcessor 클래스 자체를 수정해야하며 이는 OCP를 위배합니다.

코드 자체가 좀 간단해서 그렇게 큰 문제로 느껴지지는 않습니다만 만약 메세지를 전송하는 방식이 다양하거나 여러 기능을 묶어서 관리해야한다면 유지보수에 어려움을 겪을지도 모릅니다.

예를들어서 결제 방식에 prepareTossPay, payWithToss, cancelPayment 이렇게 기능들을 묶음으로 관리해야한다면 NaverPay 에도 비슷한 기능들을 모두 추가해줘야할텐데 다른 개발자가 코드를 넘겨 받았을 때 이를 단번에 알기란 쉽지 않겠죠.

바로 이런 불편함 점들을 Bridge 패턴이 해소 시켜줍니다!

### Bridge 패턴을 사용했을 때

그럼 Bridge 패턴을 바로 적용해보도록 하겠습니다.

Bridge 패턴의 핵심은 구현체를 추상화 하고 그 추상화된 것을 따로 class나 struct에 구현한 후 사용하는 것입니다.
그러니까 기존에 사용하던 payWithCreditCard, payWithToss, payWithNaverPay를 processPayment 로 추상화 시켜버리는거죠.

그리고 이걸 protocol 에다 박아넣겠습니다.

```Swift
protocol PaymentMethod {
  func processPayment(amount: Double)
}

```

자 그리고서 이걸 각각 필요에 맞게 구현해주면 됩니다.
우린 CreditCard, Toss, NaverPay 방식을 사용하고 있으니까 각각 구현해 주면 되겠죠?

```Swift
class CreditCard: PaymentMethod {
  func processPayment(amount: Double) {
    // 신용카드 결제로직
  }
}

class Toss: PaymentMethod {
  func processPayment(amount: Double) {
    // 토스페이 결제로직
  }
}

class NaverPay: PaymentMethod {
  func processPayment(amount: Double) {
    // 네이버페이 결제로직
  }
}
```

그럼 이걸 이제 기존 PaymentProcessor 객체에서..

```Swift
class PaymentProcessor {
  private let method: PaymentMethod // 이걸 Bridge 된거라고 표현함.
  private let amount: Amount
  
  init(method: PaymentMethod, amount: Double) {
    self.method = method
    self.amount = amount
  }
  
  func executePayment() {
    method.processPayment(amount: amount)
  }
}


```

이렇게 주입 받아서 사용하면 됩니다.

느낌 왔나요...!!!???
네 이게 바로 Bridge 패턴 입니다.

실제로 결제방식이 이것보다 많을텐데
만약 페이팔을 통한 결제를 추가하고싶다! 그러면 아래와같이 PaymentMethod 채택한 객체 하나 추가해주면 끝이죠.

```Swift
class PayPal: PaymentMethod {
  func processPayment(amount: Double) {
    // 페이팔 결제로직
  }
}

```

자 그럼 Bridge 패턴의 정의를 다시 한 번 볼까요?
 '구현(payWithCreditCard, payWithToss, payWithNaverPay)을 추상화(PaymentMethod)로 분리하고 그 구현(CreditCard, Toss, NaverPay)을 가져다 사용하는것을 얘기합니다.'

이젠 Bridge 패턴을 이해하셨을거라 믿습니다.
