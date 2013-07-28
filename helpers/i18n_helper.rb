helpers do
  def t *args
    I18n.reload! if settings.development?
    I18n.t *args
  end
end
