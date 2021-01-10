class AboutSection < SitePrism::Section
  section_xpath = "//section[@id='about-me']"
  element :tab, :xpath, "//span[text()='About']"
  element :photo, :xpath, "#{section_xpath}//img[@class='img-responsive img-circle']"
  element :name, :xpath,  "#{section_xpath}//h4"
  element :description, :xpath, "#{section_xpath}//p/span"
end