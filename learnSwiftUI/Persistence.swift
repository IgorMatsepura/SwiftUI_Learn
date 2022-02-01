//
//  Persistence.swift
//  learnSwiftUI
//
//  Created by Igor Matsepura on 07.12.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "learnSwiftUI")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}


//HEALTHKIT

//
//var workoutStartDate = Date()
//var workoutEndDate = Date()
//
//// Our workout session
//var session: HKWorkoutSession? = nil
//// Live workout builder
//var builder: HKLiveWorkoutBuilder? = nil
//// Access point for all data managed by HealthKit.
//let healthStore = HKHealthStore()
//
//let typesToShare: Set = [
//    HKQuantityType.workoutType()
//]
//
//let typesToRead: Set = [
//    HKQuantityType.quantityType(forIdentifier: .heartRate)!,
//    HKQuantityType.quantityType(forIdentifier: .bloodPressureSystolic)!,
//]
//
//
//func sessionWorkOut() {
//    
//    let configuration = HKWorkoutConfiguration()
//    configuration.activityType = .running
//    configuration.locationType = .outdoor
//    let authorizationStatus = healthStore.authorizationStatus(for: HKWorkoutType.workoutType())
//    if authorizationStatus != .sharingAuthorized {
//        print(" app is not authorized to write workout to health store")
//        // app is not authorized to write workout to health store
//        return
//    }
//    
//    
//    do {
//        session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
//        builder = session?.associatedWorkoutBuilder()
//    } catch {
//        fatalError("Unable to create the workout session!")
//        
//    }
//    
//    // Setup session and builder.
//    session?.delegate = self
//    builder?.delegate = self
//    
//    // Set the workout builder's data source.
//    builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)
//}
//
//func startWorkout() {
//    // Initialize our workout
//    sessionWorkOut()
//    
//    // Start the workout session and begin data collection
//    session?.startActivity(with: Date())
//    builder?.beginCollection(withStart: Date()) { (success, error) in
//        if !success {
//            fatalError("Error beginning collection from builder: \(String(describing: error)))")
//        }
//    }
//}
//
//}
//
//
//extension HealthKit: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
//func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
//    //
//    print("[workoutSession] Changed State: \(toState.rawValue)")
//}
//
//func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
//    //
//}
//
//func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
//    
//    for type in collectedTypes {
//        guard let quantityType = type as? HKQuantityType else {
//            return
//        }
//        switch quantityType {
//        case HKQuantityType.quantityType(forIdentifier: .heartRate):
//            let statistics = workoutBuilder.statistics(for: quantityType)
//            let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
//            let value = statistics!.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
//            let stringValue = String(Int(Double(round(1 * value!) / 1)))
//            print("[workoutBuilder] Heart Rate: \(stringValue)")
//        default:
//            return
//        }
//    }
//}
//
//func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
//    //
//    // Retreive the workout event.
//    guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
//    print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
//}
//
//
//func endWorkout() {
//    guard let workoutSession = session else { return }
//    workoutEndDate = Date()
//
//    healthStore.end(workoutSession)
//}
//
//
//}
//
