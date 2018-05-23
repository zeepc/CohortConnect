class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def date_form
    self.date.strftime("%B %d, %Y")
  end
end
