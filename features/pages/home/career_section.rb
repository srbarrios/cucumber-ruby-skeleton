class CareerSection < SitePrism::Section
  section_xpath =  "//section[@id='career']"
  element :tab, :xpath, "//span[text()='Career']"
  elements :timeline, :xpath, "#{section_xpath}//div[@id='vertical-timeline']"
  elements :jobs, :xpath, "#{section_xpath}//div[contains(@class,'vertical-timeline-content')]"
  elements :job_companies, :xpath, "#{section_xpath}//h2/span"
  elements :job_titles, :xpath, "#{section_xpath}//small/span"
  elements :job_descriptions, :xpath, "#{section_xpath}//div/p"
end