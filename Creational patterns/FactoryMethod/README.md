# Factory Method

Factory Method는 Factory pattern과 더불어 많이 거론됩니다. 구글에서 Factory Mehtod에 대해서 검색해보면 Factory pattern과 함께 혼용되어 사용하는 경우도 종종 보이더라고요.

**하지만 엄연히 이 둘은 다릅니다.**

팩토리 패턴은 객체를 생성하는 자주 변경되는 어떤 로직을 클래스나 구조체로(또는 함수로) 떼어내어 사용하는 것을 말합니다.

하지만 팩토리 메서드는 객체를 생성하는 것을 따로 분리된 클래스나 구조체로 캡슐화를 하는 것이 아니라 **객체를 생성하는 함수를 서브클래스에게 위임**하는 것을 의미합니다.

그냥 서로 다른것이라 생각하시는 게 마음 편하실지도 모릅니다😅

자 그럼 팩토리 메서드가 **"객체 생성을 서브클래스에게 위임한다~"** 이랬죠? 바로 코드로 보시죠.

아래와 같이 VideoModifier가 있다고 가정해 보겠습니다.

```swift
protocol VideoModifier {
 func addWaterMark(_ video: Video) -> Video
 func generateWaterMarkLayer() -> VideoLayer
}
```

그리고 addWaterMark 함수만 구현해 줍시다.

```swift
extension VideoModifier {
 func addWaterMark(_ video: Video) -> Video {
  let waterMarkLayer = generateWaterMarkLayer()
  let render = video.renderMode()
  render.addLayer(waterMarkLayer)
  let video = render.finishRender()
  return video
 }
}
```

구현체를 잘 보면 generateWaterMarkLayer()를 사용한 것을 볼 수 있습니다.

그리고 우리는 아직 이걸 구현해주진 않았죠.

그럼 언제 구현하냐?

### 네!! 팩토리 메서드의 본질인..! 서브클래스에서 구현해주면 됩니다

만약 VideoModifier 프로토콜을 채택한 ShortFormVideoModifier와 ClassicFormVideoModifier를 구현해주고싶다고 해보겠습니다.

두 비디오의 스타일이 다르니 워터마크 레이어도 각자 다르게 생성해줘야겠죠?

일단 만들어봅시다.

```swift
class ShortFormVideoModifier: VideoModifier {
 func generateWaterMarkLayer() -> VideoLayer {
  // 숏폼 비디오에 맞는 워터마크 생성...
  return videoLayer
 }
}

class ClassicFormVideoModifier: VideoModifier {
 func generateWaterMarkLayer() -> VideoLayer {
  // 전통적인 비디오에 맞는 워터마크 생성...
  return videoLayer
 }
}
```

자 이렇게 VideoModifier라는 프로토콜을 채택하는데 우린 이미 extension을 통해서 addWaterMark는 구현하였고 그 안에서 사용하는 generateWaterMarkLayer 함수만 서브클래스에게 위임해서 각 ShortFormVideoModifier, ClassicFormVideoModifier에서 generateWaterMarkLayer를 구현해서 각기 다른 스타일로 VideoLayer를 생성해주는 모습을 볼 수 있습니다.

이렇게 객체를 생성하는 메서드를 추상화시켜 만들어주면 확장에 굉장히 유연한 구조를 가져갈 수 있습니다.

팩토리 메서드와 팩토리 패턴.. 이름 때문에 이 둘을 엮어서 보려는 경향이 생기기 마련인데

위키에서도 그러는데 애초에 팩토리 메서드는 이름을 좀 잘못지은 것 같다고 얘기하더군요..

그래서 서로 그냥 다른 디자인 패턴이라고 보는게 편할 것 같습니다.

이상!
