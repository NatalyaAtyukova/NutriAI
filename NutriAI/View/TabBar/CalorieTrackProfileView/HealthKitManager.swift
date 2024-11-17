import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()

    // MARK: - Request Authorization
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, NSError(domain: "HealthKit not available", code: -1, userInfo: nil))
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!,
            HKObjectType.workoutType()
        ]

        healthStore.requestAuthorization(toShare: nil, read: readTypes, completion: completion)
    }

    // MARK: - Fetch Steps
    func fetchSteps(completion: @escaping (Double?, Error?) -> Void) {
        fetchQuantitySum(
            for: HKQuantityType.quantityType(forIdentifier: .stepCount)!,
            unit: HKUnit.count(),
            completion: completion
        )
    }

    // MARK: - Fetch Active Energy Burned
    func fetchActiveEnergy(completion: @escaping (Double?, Error?) -> Void) {
        fetchQuantitySum(
            for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            unit: HKUnit.kilocalorie(),
            completion: completion
        )
    }

    // MARK: - Fetch Exercise Minutes
    func fetchExerciseMinutes(completion: @escaping (Double?, Error?) -> Void) {
        fetchQuantitySum(
            for: HKQuantityType.quantityType(forIdentifier: .appleExerciseTime)!,
            unit: HKUnit.minute(),
            completion: completion
        )
    }

    // MARK: - Fetch Sleep Analysis
    func fetchSleepAnalysis(completion: @escaping (Double?, Error?) -> Void) {
        let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        let startOfDay = Calendar.current.startOfDay(for: Date())

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
        let query = HKSampleQuery(sampleType: sleepType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { _, results, error in
            guard error == nil else {
                completion(nil, error)
                return
            }

            let totalSleep = results?
                .compactMap { $0 as? HKCategorySample }
                .filter { $0.value == HKCategoryValueSleepAnalysis.asleep.rawValue }
                .reduce(0) { $0 + $1.endDate.timeIntervalSince($1.startDate) } ?? 0

            completion(totalSleep / 3600, nil) // Convert seconds to hours
        }

        healthStore.execute(query)
    }
    
    func fetchWeeklyCalories(completion: @escaping ([Double]?, Error?) -> Void) {
            let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            var weeklyCalories: [Double] = Array(repeating: 0, count: 7)
            let calendar = Calendar.current
            let now = Date()

            let dispatchGroup = DispatchGroup()

            for dayOffset in 0..<7 {
                dispatchGroup.enter()

                let startOfDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: -dayOffset, to: now)!)
                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
                let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                    if let result = result, let sum = result.sumQuantity() {
                        weeklyCalories[6 - dayOffset] = sum.doubleValue(for: .kilocalorie())
                    }
                    dispatchGroup.leave()
                }
                healthStore.execute(query)
            }

            dispatchGroup.notify(queue: .main) {
                completion(weeklyCalories, nil)
            }
        }

    // MARK: - Generic Quantity Fetch
    private func fetchQuantitySum(for quantityType: HKQuantityType, unit: HKUnit, completion: @escaping (Double?, Error?) -> Void) {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)

        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            guard let sum = result?.sumQuantity() else {
                completion(nil, error)
                return
            }
            completion(sum.doubleValue(for: unit), nil)
        }

        healthStore.execute(query)
    }

    // MARK: - Helper for Predicate Creation
    private func createDailyPredicate() -> NSPredicate {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return HKQuery.predicateForSamples(withStart: startOfDay, end: Date(), options: .strictStartDate)
    }
}
