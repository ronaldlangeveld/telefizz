class Integration < ApplicationRecord
  belongs_to :user

  # STI subclasses should define their own validations and accessors
end
