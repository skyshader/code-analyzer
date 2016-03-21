ApiPagination.configure do |config|
  # If you have both gems included, you can choose a paginator.
  config.paginator = :will_paginate

  # By default, this is set to 'Total'
  config.total_header = 'Paginate-Total'

  # By default, this is set to 'Per-Page'
  config.per_page_header = 'Paginate-Per-Page'

  # Optional: set this to add a header with the current page number.
  config.page_header = 'Paginate-Page'

  # Optional: what parameter should be used to set the page option
  config.page_param = :page

  # Optional: what parameter should be used to set the per page option
  config.per_page_param = :per_page
end