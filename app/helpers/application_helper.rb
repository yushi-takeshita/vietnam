module ApplicationHelper
  def full_title(page_title = "")
    base_title = "PostOne"
    if page_title.empty?
      base_title
    else
      base_title + " / " + page_title
    end
  end

  def another_locale
    I18n.locale == :vi ? :ja : :vi
  end
end
