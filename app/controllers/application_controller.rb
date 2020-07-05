class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale, :set_parents

  def set_locale
    I18n.locale = locale
  end

  def locale
    @locale ||= params[:locale] ||= I18n.default_locale
  end

  def default_url_options(options = {})
    options.merge(locale: locale)
  end

  def set_parents
    @parents = Category.where(ancestry: nil)
  end

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    unless logged_in?
      flash[:danger] = t("users.new.flash.ログインしてください")
      redirect_to login_url
    end
  end
end
