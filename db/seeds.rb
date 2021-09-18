User.create!(
    name: "test",
    email: "test@test.com",
    term: 99,
    image_url: "./assets/img/default_icon.png",
    area_id: 1,
    password: "test"
)

Area.create!(
    [
        {
            name: "関東",
            lowercase_name: "east"
            
        },
        {
            name: "関西",
            lowercase_name: "west"
            
        },
        {
            name: "東海",
            lowercase_name: "central"
            
        },
        {
            name: "オンライン",
            lowercase_name: "online"
            
        },
    ]
)

Place.create!(
    [
        {
            name: "白金高輪",
            lowercase_name: "shirokane",
            area_id: 1
        },
        {
            name: "秋葉原",
            lowercase_name: "akihabara",
            area_id: 1
        },
        {
            name: "池袋",
            lowercase_name: "ikebukuro",
            area_id: 1
        },
        {
            name: "横浜",
            lowercase_name: "yokohama",
            area_id: 1
        },
        {
            name: "大阪",
            lowercase_name: "osaka",
            area_id: 2
        },
        {
            name: "名古屋",
            lowercase_name: "nagoya",
            area_id: 3
        },
        {
            name: "オンライン",
            lowercase_name: "online",
            area_id: 4
        },
    ]
)

Schedule.create!(
    [
        {
            kind: "毎週",
            dayOfWeek: "火曜"
        },
        {
            kind: "毎週",
            dayOfWeek: "水曜"
        },
        {
            kind: "毎週",
            dayOfWeek: "木曜"
        },
        {
            kind: "毎週",
            dayOfWeek: "金曜"
        },
        {
            kind: "毎週",
            dayOfWeek: "土曜"
        },
        {
            kind: "A",
            dayOfWeek: "土曜"
        },
        {
            kind: "A",
            dayOfWeek: "日曜"
        },
        {
            kind: "B",
            dayOfWeek: "土曜"
        },
        {
            kind: "B",
            dayOfWeek: "日曜"
        },
    ]
)

Classroom.create!(
    [
        {
            lowercase_name: "tue_weekly_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 1
        },
        {
            lowercase_name: "wed_weekly_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 2
        },
        {
            lowercase_name: "thu_weekly_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 3
        },
        {
            lowercase_name: "fri_weekly_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 4
        },
        {
            lowercase_name: "sat_weekly_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 5
        },
        {
            lowercase_name: "sun_a_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 7
        },
        {
            lowercase_name: "sat_b_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 8
        },
        {
            lowercase_name: "sun_b_shirokane",
            area_id: 1,
            place_id: 1,
            schedule_id: 9
        },
        {
            lowercase_name: "sun_b_akihabara",
            area_id: 1,
            place_id: 2,
            schedule_id: 9
        },
        {
            lowercase_name: "sun_b_ikebukuro",
            area_id: 1,
            place_id: 3,
            schedule_id: 9
        },
        {
            lowercase_name: "sat_a_yokohama",
            area_id: 1,
            place_id: 4,
            schedule_id: 6
        },
        {
            lowercase_name: "sun_a_yokohama",
            area_id: 1,
            place_id: 4,
            schedule_id: 7
        },
        {
            lowercase_name: "fri_weekly_osaka",
            area_id: 2,
            place_id: 5,
            schedule_id: 4
        },
        {
            lowercase_name: "sat_a_osaka",
            area_id: 2,
            place_id: 5,
            schedule_id: 6
        },
        {
            lowercase_name: "sun_a_osaka",
            area_id: 2,
            place_id: 5,
            schedule_id: 7
        },
        {
            lowercase_name: "sun_b_osaka",
            area_id: 2,
            place_id: 5,
            schedule_id: 9
        },
        {
            lowercase_name: "sat_a_nagoya",
            area_id: 3,
            place_id: 6,
            schedule_id: 6
        },
        {
            lowercase_name: "sun_a_nagoya",
            area_id: 3,
            place_id: 6,
            schedule_id: 7
        },
        {
            lowercase_name: "fri_weekly_online",
            area_id: 4,
            place_id: 7,
            schedule_id: 4
        },
        {
            lowercase_name: "sat_weekly_online",
            area_id: 4,
            place_id: 7,
            schedule_id: 5
        },
        {
            lowercase_name: "sun_b_online",
            area_id: 4,
            place_id: 7,
            schedule_id: 9
        },
    ]
)

Course.create!(
    [
        {
            official_name: "iPhoneアプリプログラミングコース",
            popular_name: "iPhone",
            lowercase_name: "iphone"
        },
        {
            official_name: "Androidアプリプログラミングコース",
            popular_name: "Android",
            lowercase_name: "android"
        },
        {
            official_name: "Unityゲームプログラミングコース",
            popular_name: "Unity",
            lowercase_name: "unity"
        },
        {
            official_name: "Webデザインコース",
            popular_name: "Webデザイン",
            lowercase_name: "webd"
        },
        {
            official_name: "Webサービスプログラミングコース",
            popular_name: "Webサービス",
            lowercase_name: "webs"
        },
    ]   
)