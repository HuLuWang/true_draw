# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

    user = User.create!(nickname: "麻将",
                        avatar: "https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLYOuLxFCbeNLU18MthwzvanC8sAvgVW4Nk1EJBY6qnw9BibOwy8RIxH2R43fhdY3CraUbja0PpRUw/132",
                        mobile: 17343005384
    )
    option = {
        title: "第一第一",
        image: "https://onebillion-cloud-prod.oss-cn-shanghai.aliyuncs.com/1583764093361.jpg",
        content: "嘿嘿嘿嘿嘿嘿嘿嘿嘿".to_json,
        condition: "time",
        lottery_time: Time.now + 1.days,
        user_id: user.id,
        award_list: [
            {
                name: "西风",
                image: "https://onebillion-cloud-prod.oss-cn-shanghai.aliyuncs.com/1583764093361.jpg",
                number: 1,
            },
            {
                name: "南风",
                image: "https://onebillion-cloud-prod.oss-cn-shanghai.aliyuncs.com/1583764093361.jpg",
                number: 3,
            },
               ]

    }
    Lottery.generate(option)