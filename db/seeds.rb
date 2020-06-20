life_hack = Category.create(name: "生活の知恵")
question = Category.create(name: "質問・相談")
question.children.create(
  [{ name: "言葉/文化" }, { name: "技能実習" }, { name: "申請/手続き" }, { name: "お金" }, { name: "その他" }]
)
