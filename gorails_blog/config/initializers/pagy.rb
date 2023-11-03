# Optionally override some Pagy defaults with your own in the Pagy initializer
Pagy::DEFAULT[:items] = 25 # Items per page
# Pagy::DEFAULT[:size]  = [1, 4, 4, 1] # Navigation bar links

# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
