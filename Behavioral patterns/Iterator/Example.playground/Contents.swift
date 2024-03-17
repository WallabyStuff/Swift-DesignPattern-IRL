import Foundation

struct MigrationIterator: IteratorProtocol, Sequence {

  let steps: [MigrationStep]
  var currentIndex = 0
  
  mutating
  func next() -> MigrationStep? {
    if hasNext() {
      let step = steps[currentIndex]
      currentIndex += 1
      return step
    } else {
      return nil
    }
  }
  
  func hasNext() -> Bool {
    return currentIndex < steps.count
  }
}

struct MigrationCollection: Sequence {
  private var steps: [MigrationStep]
  private let currentVersion: Int
  private let targetVersion: Int
  
  init(steps: [MigrationStep], currentVersion: Int, targetVersion: Int) {
    self.steps = steps
    self.currentVersion = currentVersion
    self.targetVersion = targetVersion
  }
  
  func makeIterator() -> MigrationIterator {
    let filteredSteps = steps.filter { $0.migrationVersion > currentVersion && $0.migrationVersion <= targetVersion }
    return MigrationIterator(steps: filteredSteps)
  }
}

protocol MigrationStep {
  var migrationVersion: Int { get }
  func migrate()
}

struct V1_to_V2: MigrationStep {
  let migrationVersion: Int = 1
  func migrate() {
    print("버전 1 에서 버전2 로 마이그레이션 완료.")
  }
}

struct V2_to_V3: MigrationStep {
  let migrationVersion: Int = 2
  func migrate() {
    print("버전 2 에서 버전3 로 마이그레이션 완료.")
  }
}

struct V3_to_V4: MigrationStep {
  let migrationVersion: Int = 3
  func migrate() {
    print("버전 3 에서 버전4 로 마이그레이션 완료.")
  }
}

struct V4_to_V5: MigrationStep {
  let migrationVersion: Int = 4
  func migrate() {
    print("버전 4 에서 버전5 로 마이그레이션 완료.")
  }
}

let collection = MigrationCollection(steps: [
  V1_to_V2(),
  V2_to_V3(),
  V3_to_V4(),
  V4_to_V5()
], currentVersion: 2, targetVersion: 4)

var iterator = collection.makeIterator()
for next in iterator {
  next.migrate()
}
