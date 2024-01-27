import Foundation

struct Event: Hashable {
	let title: String
	let description: String
	let imageName: String
	let eventDate: String
	let leaderIds: [Int]
	let influence: String
}
