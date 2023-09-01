require_relative '../sections/product_elements'
require_relative '../sections/header'
require_relative '../sections/footer'
require_relative '../sections/login_modal'

module Pages
    class SearchResult < SitePrism::Page
        set_url '/search'

        section :header, Sections::Header, 'header'
        section :footer, Sections::Footer, 'footer'
        section :login_modal, Sections::LoginModal, 'login-modal .PopUp'
        sections :products, Sections::ProductElements, 'div.categoryRight li.ng-scope'
        
        def access_product_of_list(index)
            products[index].product_img.click
        end
    end
end