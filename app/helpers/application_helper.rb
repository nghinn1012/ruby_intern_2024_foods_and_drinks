module ApplicationHelper
  include Pagy::Frontend
  include FoodsHelper
  def full_title page_title
    base_title = Settings.name
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def show_errors object, field_name
    return unless object.errors.any?

    return if object.errors.messages[field_name].blank?

    object.errors.full_messages_for(field_name)[0]
  end

  def count_item cart_items
    cart_items.sum{|item| item["food_quantity"]}
  end

  def current_language_icon
    case I18n.locale
    when :vi
      image_tag("vi.png", class: "d-flex align-items-center locale-icon")
    when :en
      image_tag("en.png", class: "d-flex align-items-center locale-icon")
    end
  end
end
