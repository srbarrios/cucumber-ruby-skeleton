class BlogPage < SitePrism::Page
  set_url '/blog/'
  block_xpath =  "//div[contains(@class,'wrapper-content')]"
  elements :posts, :xpath, "#{block_xpath}//div[contains(@class,'ibox-content')]"
  elements :post_titles, :xpath, "#{block_xpath}//h2"
  elements :post_summaries, :xpath, "#{block_xpath}//p"
  elements :post_images, :xpath, "#{block_xpath}//img"
end