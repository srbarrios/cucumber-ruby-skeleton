class BlogSection < SitePrism::Section
  section_xpath =  "//section[@id='blog']"
  element :tab, :xpath, "//span[text()='Blog']"
  element :button, :xpath, "#{section_xpath}//span[text()='My Blog']"
end