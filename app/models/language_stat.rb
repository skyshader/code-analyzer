class LanguageStat < ActiveRecord::Base

  belongs_to :supported_language
  belongs_to :branch

end
