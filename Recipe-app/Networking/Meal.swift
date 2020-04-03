struct Meal: Decodable {
    struct Hit: Decodable {
        struct Recipe: Decodable {
            struct Ingredient: Decodable{
                var text: String
                var weight: Double
            }
            var ingredients: [Ingredient]
            var label: String
            var image: String
            var calories: Double
            var totalWeight: Double
            var totalTime: Double
        }
        var recipe: Recipe
    }
    var hits: [Hit]?
}
