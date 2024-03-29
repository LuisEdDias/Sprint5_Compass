Dado('que esteja na página inicial do e-commerce') do
    @home = Pages::HomePage.new
    @home.load
end

Então('a home page é exibida corretamente') do
    expect(@home.header.visible?).to be_truthy
    expect(@home.footer.visible?).to be_truthy
    expect(@home.our_products.all_there?).to be_truthy
end

Quando('realizar a pesquisa de um produto válido') do
    valid_product = Factory::Static.static_data 'valid_product'
    @home.search_for valid_product
    @search_page = Pages::SearchPage.new
end
  
Então('deve ver uma lista de resultados') do
    expect(@search_page.products_list.visible?).to be_truthy
end

Então('deve ver a descrição dos itens') do
    @search_page.products_list.products.each do |element|
        expect(element.all_there?).to be_truthy
    end
end

Quando('realizar a pesquisa de um produto inválido') do
    invalid_product = Factory::Static.static_data 'invalid_product'
    @home.search_for invalid_product
    @search_page = Pages::SearchPage.new
end
  
Então('deve ver que não foram encontrados resultados') do
    expect(@search_page.no_results_label.visible?).to be_truthy
end

Quando('acessa uma categoria {string}') do |categoria|
    @home.our_products.public_send(categoria).click
    @search_page = Pages::SearchPage.new
end

Quando('selecionar uma imagem') do
    @home.btn_slider_steps.last.click
end
    
Então('a imagem é marcada como selecionada') do
    expect(@home.btn_slider_steps.last['class']).to include 'selected'
end

Quando('acessa a funcionalidade chat') do
    @home.contact_us.btn_chat.click
end
  
Então('o chat é aberto em nova janela') do
    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window popup
    expect(page.current_url).to include '/chat'
end

Quando('envia o formulário de contato com dados válidos') do
    data_form = Factory::Dynamic.valid_data_form_contact_us
    @home.contact_us.select_category_list.first.click
    @home.contact_us.select_products_list.first.click
    @home.contact_us.input_email.set data_form[:email]
    @home.contact_us.text_area.set data_form[:message]
    @home.contact_us.btn_send.click
end
  
Então('uma confirmação é exibida') do
    @home.contact_us.wait_until_send_confirme_label_visible
    message_ok = Factory::Static.static_data_two_args('message', 'contact_us_form_send_ok_msg')
    expect(@home.contact_us.send_confirme_label.text).to eq message_ok
end

Quando('acessa a rede social {string} da seção FOLLOW US') do |link|
    follow_us = Factory::Static.static_data_two_args('footer_follow_us', link)
    @home.footer.public_send(follow_us.to_sym).click
    popup = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window popup
end
  
Então('é redirecionado para página correta {string}') do |page_url|
    follow_us = Factory::Static.static_data_two_args('footer_follow_us', page_url)
    expect(page.current_url).to include follow_us
end

Quando('retornar para home através do logo') do
    @home.header.logo.click
end
