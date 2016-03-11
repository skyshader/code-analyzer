class SupportedLanguage < ActiveRecord::Base

  has_many :file_lists
  has_many :language_stats

end
