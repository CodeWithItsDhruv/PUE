import Foundation
import Firebase

class EventManager {
    let ref = Database.database().reference()

    func fetchEvents(category: String, completion: @escaping ([Event]) -> Void) {
        ref.child("event")
            .child(category.lowercased())
            .observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                    completion([])
                    return
                }

                let events = dataSnapshot.compactMap { (data: DataSnapshot) -> Event? in
                    guard let eventData = data.value as? [String: Any],
                          let name = eventData["name"] as? String,
                          let date = eventData["date"] as? String,
                          let time = eventData["time"] as? String,
                          let place = eventData["place"] as? String,
                          let imageURL = eventData["imageURL"] as? String
                    else {
                        return nil
                    }

                    return Event(name: name, date: date, time: time, place: place, imageURL: imageURL)
                }

                completion(events)
            }
    }
}

struct Event {
    let name: String
    let date: String
    let time: String
    let place: String
    let imageURL: String
}
