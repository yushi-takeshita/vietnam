crumb :root do
  link "Home", root_path
end

crumb :categories do
  link t(".カテゴリー"), category_path
end

crumb :category do |category|
  if category.parent
    category_parent_name = I18n.locale == :vi ? category.parent.vi_name : category.parent.ja_name
    link category_parent_name, category_path(category.parent.id)
  end
  category_name = I18n.locale == :vi ? category.vi_name : category.ja_name
  link category_name, category_path
  parent :categories
end

# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
