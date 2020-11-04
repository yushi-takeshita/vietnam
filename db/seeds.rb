Category.create!(ja_name: "生活の知恵", vi_name: "Sự khôn ngoan của cuộc sống")

# [
#   ["生活の知恵", "Sự khôn ngoan của cuộc sống"],
#   ["仲間募集", "Tuyển dụng bạn bè"],
#   ["売ります・あげます", "Bán và mua"],
#   ["雑談", "Chat"],
#   ["質問・相談", "Câu hỏi và tham vấn"]
# ].each do |ja_name, vi_name|
#   Category.create!(
#     { ja_name: ja_name, vi_name: vi_name }
#   )
# end

# parent = Category.find_by(ja_name: "質問・相談")
# [
# ["言葉/文化", "Ngôn ngữ và văn hóa"],
# ["技能実習", "Tập huấn kỹ thuật"],
# ["申請/手続き", "Ứng dụng và thủ tục"],
# ["お金のコト", "Tiền"],
# ["その他", "Khác"]
# ].each do |ja_name, vi_name|
# parent.children.create!(
# { ja_name: ja_name, vi_name: vi_name }
# )
# end
