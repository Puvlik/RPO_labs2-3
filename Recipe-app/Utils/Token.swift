enum Token {
    enum Recipe {
        static var app_id = keys[0]["id"]
        static var app_key = keys[0]["key"]
        private static var keys = [
            [
                "id": "06c05209",
                "key": "562d26ba9cf9eb68cf922ef7d7ebeb33"
            ],
            [
                "id": "fe5cb8b9",
                "key": "7e63ea11bdb617e8af9758cfb1b9c0f6"
            ],
            [
                "id": "f402f4c8",
                "key": "3f988dd87d9307b9d18fa85832bbd645"
            ],
            [
                "id": "b317e8f7",
                "key": "44573fbcfd5ee50f70d811bb2cbfe9d8"
            ]
        ]
        static func newKey() {
            if keys.count > 1 {
                keys.removeFirst()
                app_id = keys[0]["id"]
                app_key = keys[0]["key"]
            }
        }
    }
    
    enum Food {
        static var app_id = keys[0]["id"]
        static var app_key = keys[0]["key"]
        private static var keys = [
            [
                "id": "f2618cf4",
                "key": "61024704d1f7d0c71df6727e94ddf977"
            ],
            [
                "id": "9d420e37",
                "key": "4896968ba1da4a0c7c3884f1a9c9acb0"
            ],
            [
                "id": "e390e10a",
                "key": "d430a4e7db4e2b458c69e20e8f64ee75"
            ],
            [
                "id": "435385bb",
                "key": "08224c0a972ab18f63ba5e99bfe28907"
            ]
        ]
        static func newKey() {
            if keys.count > 1 {
                keys.removeFirst()
                app_id = keys[0]["id"]
                app_key = keys[0]["key"]
            }
        }
    }
}


