class Goal < ApplicationRecord
  enum status: [ :active, :important, :suspended, :someday, :archived ]
  belongs_to :user
  belongs_to :area, optional:true
end
