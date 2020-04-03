struct FoodVariety: Decodable {
    struct Hint: Decodable {
        struct Food: Decodable {
            struct Nutrient: Decodable {
                var ENERC_KCAL: Double?
                var PROCNT: Double?
                var FAT: Double?
                var CHOCDF: Double?
            }
            var nutrients: Nutrient
            var label: String
        }
        var food: Food
    }
    var hints: [Hint]?
}
