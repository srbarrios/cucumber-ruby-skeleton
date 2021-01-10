class HomePage < SitePrism::Page
  set_url '/index.html'
  section :about, AboutSection, '#about-me'
  section :career, CareerSection, '#career'
  section :blog, BlogSection, '#blog'

  def go_to_about
    about.tab.click
  end

  def go_to_career
    career.tab.click
  end

  def go_to_blog
    blog.tab.click
  end
end