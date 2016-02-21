class Bracket < ActiveRecord::Base
  class PicksValidator < ActiveModel::Validator
    def validate(record)
      picks = record.picks
      if !picks.is_a?(Array)
        record.errors[:picks] << "Must be an array of team IDs"
      elsif picks.length != 63
        record.errors[:picks] << "Must have a pick for each game"
      else
        teams = Team.where(id: picks).select(&:id)
        unique_ids = Set.new(teams.map(&:id))
        picks.each do |id|
          unless unique_ids.include? id
            record.errors[:picks] << "#{id} is not a valid team ID"
          end
        end
      end
    end
  end


  belongs_to :tournament
  belongs_to :user

  serialize :picks, JSON

  validates :tournament, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :tournament_id }
  validates_with PicksValidator

end