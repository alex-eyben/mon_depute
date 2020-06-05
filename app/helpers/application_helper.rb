module ApplicationHelper
  def image_url_with_fallback(image)
    if image.empty?
      image_url "cover-image.png"
    else
      image.strip
    end
  end
end
