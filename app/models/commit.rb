class Commit < ApplicationRecord
  paginates_per 10

  validates :owner,  presence: true
  validates :repo,   presence: true
  validates :author, presence: true
end
