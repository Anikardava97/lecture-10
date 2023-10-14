
/*
 4-StationModule-ი
 With properties: moduleName: String და drone: Drone? (optional).
 Method რომელიც დრონს მისცემს თასქს.
 */

class StationModule {
    let moduleName: String
    let drone: Drone?
    
    init(moduleName: String, drone: Drone? = nil) {
        self.moduleName = moduleName
        self.drone = drone
    }
    
    func giveDroneTask (task: String) {
        if let drone = drone {
            drone.task = task
            print("Task: \(task) assigned to the drone.")
        } else {
            print("Drone is not available.")
        }
    }
}

/*
 1-ControlCenter-ი.
 With properties: isLockedDown: Bool და securityCode: String, რომელშიც იქნება რაღაც პაროლი შენახული.
 Method lockdown, რომელიც მიიღებს პაროლს, ჩვენ დავადარებთ ამ პაროლს securityCode-ს და თუ დაემთხვა გავაკეთებთ lockdown-ს.
 Method-ი რომელიც დაგვიბეჭდავს ინფორმაციას lockdown-ის ქვეშ ხომ არაა ჩვენი ControlCenter-ი.
 */

class ControlCenter: StationModule {
    var isLockedDown: Bool
    let securityCode: String
    
    init(isLockedDown: Bool, securityCode: String) {
        self.isLockedDown = isLockedDown
        self.securityCode = securityCode
        super.init(moduleName: moduleName, drone: drone)
    }
    
    func lockdown(password: String) {
        if password == securityCode {
            isLockedDown = true
            print("Control Center is locked down.")
        } else {
            isLockedDown = false
            print("Password is not correct. Lockdown failed.")
        }
    }
    
    func isControlCenterUnderLockdown() {
        if isLockedDown {
            print("Control Center is under lockdown.")
        } else {
            print("Control Center is not under lockdown.")
        }
    }
}

/*
 2-ResearchLab-ი.
 With properties: String Array - ნიმუშების შესანახად.
 Method რომელიც მოიპოვებს(დაამატებს) ნიმუშებს ჩვენს Array-ში.
 */

class ResearchLab: StationModule {
    var samples: [String] = []
    
    init() {
        super.init(moduleName: moduleName, drone: drone)
    }
    
    func addSamplesToArray(_ sample: String) {
        samples.append(sample)
        print("Sample added to Research Lab")
    }
}

/*
 3-LifeSupportSystem-ა.
 With properties: oxygenLevel: Int, რომელიც გააკონტროლებს ჟანგბადის დონეს.
 Method რომელიც გვეტყვის ჟანგბადის სტატუსზე.
 */

class LifeSupportSystem: StationModule {
    let oxygenLevel: Int
    
    init(oxygenLevel: Int) {
        self.oxygenLevel = oxygenLevel
        super.init(moduleName: moduleName, drone: drone)
    }
    
    func oxygenStatus() {
        if oxygenLevel >= 95 {
            print("normal.")
        } else if oxygenLevel >= 60 && oxygenLevel < 96 {
            print("low.")
        } else {
            print("critical, seek medical help immediately.")
        }
    }
}

/*
 5-ჩვენი ControlCenter-ი ResearchLab-ი და LifeSupportSystem-ა გავხადოთ StationModule-ის subClass.
 
 6-Drone.
 With properties: task: String? (optional), unowned var assignedModule: StationModule, weak var missionControlLink: MissionControl? (optional).
 Method რომელიც შეამოწმებს აქვს თუ არა დრონს თასქი და თუ აქვს დაგვიბჭდავს რა სამუშაოს ასრულებს ის.
 */

class Drone {
    var task: String?
    unowned var assignedModule: StationModule
    //    weak var missionControlLink: MissionControl?   -- Cannot find type 'MissionControl' in scope ამას მიწერს და ვერ ვხვდები რატო :(
    
    init(task: String? = nil, assignedModule: StationModule/*, missionControlLink: MissionControl? = nil*/) {
        self.task = task
        self.assignedModule = assignedModule
        //        self.missionControlLink = missionControlLink
    }
    
    func checkIfDroneHasTask() {
        if let task = task {
            print("Drone is \(task)")
        } else {
            print("Drone has no task.")
        }
    }
}

/*
 7-OrbitronSpaceStation-ი შევქმნათ, შიგნით ავაწყოთ ჩვენი მოდულები ControlCenter-ი, ResearchLab-ი და LifeSupportSystem-ა. ასევე ამ მოდულებისთვის გავაკეთოთ თითო დრონი და მივაწოდოთ ამ მოდულებს რათა მათ გამოყენება შეძლონ.
 ასევე ჩვენს OrbitronSpaceStation-ს შევუქმნათ ფუნქციონალი lockdown-ის რომელიც საჭიროების შემთხვევაში controlCenter-ს დალოქავს.
 */

class OrbitronSpaceStation {
    let controlCenter: ControlCenter
    let researchLab: ResearchLab
    let lifeSupportSystem: LifeSupportSystem
    let controlCenterDrone: Drone
    let researchLabDrone: Drone
    let lifeSupportSystemDrone: Drone
    
    init(controlCenter: ControlCenter, researchLab: ResearchLab, lifeSupportSystem: LifeSupportSystem, controlCenterDrone: Drone, researchLabDrone: Drone, lifeSupportSystemDrone: Drone) {
        self.controlCenter = controlCenter
        self.researchLab = researchLab
        self.lifeSupportSystem = lifeSupportSystem
        self.controlCenterDrone = Drone(assignedModule: controlCenter)
        self.researchLabDrone = Drone(assignedModule: researchLab)
        self.lifeSupportSystemDrone = Drone(assignedModule: lifeSupportSystem)
    }
    
    func OrbitronLocksDownControlCenter(password: String) {
        controlCenter.lockdown(password: password)
    }
    
/*
8-MissionControl.
With properties: spaceStation: OrbitronSpaceStation? (optional).
Method რომ დაუკავშირდეს OrbitronSpaceStation-ს და დაამყაროს მასთან კავშირი.
Method requestControlCenterStatus-ი.
Method requestOxygenStatus-ი.
Method requestDroneStatus რომელიც გაარკვევს რას აკეთებს კონკრეტული მოდულის დრონი.
*/
    
    class MissionControl {
        var spaceStation: OrbitronSpaceStation?
        
        func connectToOrbitronSpaceStation (spaceStation: OrbitronSpaceStation) {
            self.spaceStation = spaceStation
            print("Mission Control is connected to Orbitron Space Station.")
        }
        
        func checkControlCenterStatus() {
            if let spaceStation = spaceStation {
            let controlCenterStatus = spaceStation.controlCenter.isControlCenterUnderLockdown()
                // აქ რატო მაქვს ეს ვორნინგი? Constant 'controlCenterStatus' inferred to have type '()', which may be unexpected
                print("Control Center in Orbitron Station is \(controlCenterStatus).")
            } else {
                print("Mission Control is not connected to Orbitron Space Station.")
            }
        }
        
        func requestOxygenStatus() {
            if let spaceStation = spaceStation {
            let oxygenStatus = spaceStation.lifeSupportSystem.oxygenStatus()
                print("Oxygen level is \(oxygenStatus)")
            } else {
                print("Mission Control is not connected to Orbitron Space Station.")
            }
            
            func requestDroneStatus() {
                if let spaceStation = spaceStation {
                    let controlCenterDroneTask = spaceStation.controlCenterDrone.task
                    let researchLabDroneTask = spaceStation.researchLabDrone.task
                    let lifeSupportSystemDroneTask = spaceStation.lifeSupportSystemDrone.task
                    print("Control Center's Drone: \(controlCenterDroneTask ?? "No task")")
                    print("Research Center's Drone: \(researchLabDroneTask ?? "No task")")
                    print("Life Support System's Drone: \(lifeSupportSystemDroneTask ?? "No task")")
                } else {
                    print("Mission Control is not connected to Orbitron Space Station.")
                }
            }
        }
/*
 9-და ბოლოს
 შევქმნათ OrbitronSpaceStation,
 შევქმნათ MissionControl-ი,
 missionControl-ი დავაკავშიროთ OrbitronSpaceStation სისტემასთან,
 როცა კავშირი შედგება missionControl-ით მოვითხოვოთ controlCenter-ის status-ი.
 controlCenter-ის, researchLab-ის და lifeSupport-ის მოდულების დრონებს დავურიგოთ თასქები.
 შევამოწმოთ დრონების სტატუსები.
 შევამოწმოთ ჟანგბადის რაოდენობა.
 შევამოწმოთ ლოქდაუნის ფუნქციონალი და შევამოწმოთ დაილოქა თუ არა ხომალდი სწორი პაროლი შევიყვანეთ თუ არა.
*/
        let controlCenter = ControlCenter(isLockedDown: false, securityCode: "1111")
        let researchLab = ResearchLab()
        let lifeSupportSystem = LifeSupportSystem(oxygenLevel: 96)
        
//        ვერ ვასწორებ ამ ერორებს, დავიტანჯე :((( ვერ ვხვდები რა მაქვს არასწორად
        
//        let controlCenterDrone = Drone(assignedModule: controlCenter)
//        let researchLabDrone = Drone(assignedModule: researchLab)
//        let lifeSupportSystem = Drone(assignedModule: lifeSupportSystem)
//        
//        ამის შემდეგ საერთოდ არაფერს მიბეჭდავს და ჩაკომენტარებული მაქვს  :((
        
//        let orbitronSpaceStation = OrbitronSpaceStation(
//            controlCenter: controlCenter,
//            researchLab: researchLab,
//            lifeSupportSystem: lifeSupportSystem,
//            controlCenterDrone: controlCenterDrone,
//            researchLabDrone: researchLabDrone,
//            lifeSupportSystemDrone: lifeSupportSystemDrone
//        )
        
        let missionControl = MissionControl()
//        missionControl.connectToOrbitronSpaceStation(spaceStation: orbitronSpaceStation)
        
//        missionControl.checkControlCenterStatus()
        
//        orbitronSpaceStation.controlCenterDrone.checkIfDroneHasTask()
//        orbitronSpaceStation.controlCenter.giveDroneTask(task: "blabla")
        
//        missionContro.requestDroneStatus()
        
//        missionControl.requestOxygenStatus()
        
        
//         orbitronSpaceStation.OrbitronLocksDownControlCenter(password: "3333")
        
        
        
/*
 10- გამოიყენეთ access levels სადაც საჭიროა (ცვლადებთან და მეთოდებთან).
*/
        
