# Represents a specific kind of feed. See migration file for details
# @author Chris Loftus
class Feed < ApplicationRecord
  has_and_belongs_to_many :broadcasts
end
