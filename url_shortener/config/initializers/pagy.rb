Pagy::DEFAULT[:items] = 10
# Pagy::DEFAULT[:size]  = [1, 4, 4, 1] # Navigation bar links

require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
