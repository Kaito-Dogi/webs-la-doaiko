User.create!(
    name: "test",
    email: "test@test.com",
    term: 99,
    image_url: "./assets/img/default_icon.png",
    area_id: 1,
    password: "test"
)

areas = ["関東", "関西", "東海", "オンライン"]
areas.each do |area|
    Area.create!(name: area)
end

Place.create!(
    [
        {
            name: "白金高輪",
            area_id: 1
        },
        {
            name: "秋葉原",
            area_id: 1
        },
        {
            name: "池袋",
            area_id: 1
        },
        {
            name: "横浜",
            area_id: 1
        },
        {
            name: "大阪",
            area_id: 2
        },
        {
            name: "名古屋",
            area_id: 3
        },
        {
            name: "オンライン",
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
            area_id: 1,
            place_id: 1,
            schedule_id: 1
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 2
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 3
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 4
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 5
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 7
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 8
        },
        {
            area_id: 1,
            place_id: 1,
            schedule_id: 9
        },
        {
            area_id: 1,
            place_id: 2,
            schedule_id: 9
        },
        {
            area_id: 1,
            place_id: 3,
            schedule_id: 9
        },
        {
            area_id: 1,
            place_id: 4,
            schedule_id: 6
        },
        {
            area_id: 1,
            place_id: 4,
            schedule_id: 7
        },
        {
            area_id: 2,
            place_id: 5,
            schedule_id: 4
        },
        {
            area_id: 2,
            place_id: 5,
            schedule_id: 6
        },
        {
            area_id: 2,
            place_id: 5,
            schedule_id: 7
        },
        {
            area_id: 2,
            place_id: 5,
            schedule_id: 9
        },
        {
            area_id: 3,
            place_id: 6,
            schedule_id: 6
        },
        {
            area_id: 3,
            place_id: 6,
            schedule_id: 7
        },
        {
            area_id: 4,
            place_id: 7,
            schedule_id: 4
        },
        {
            area_id: 4,
            place_id: 7,
            schedule_id: 5
        },
        {
            area_id: 4,
            place_id: 7,
            schedule_id: 9
        },
    ]
)