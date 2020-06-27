json.array! @children do |child|
  json.id child.id
  if I18n.locale.to_s == "ja"
    json.name child.ja_name
  elsif I18n.locale.to_s == "vi"
    json.name child.vi_name
  end
end
