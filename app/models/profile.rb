# == Schema Information
#
# Table name: profiles
#
#  id                :integer          not null, primary key
#  birth_date        :date
#  city              :string
#  country           :string
#  discovery_of_site :text
#  first_name        :string
#  gender            :string
#  last_name         :string
#  state             :string
#  street_name       :string
#  zip_code          :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :integer          not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#

class Profile < ActiveRecord::Base
  POSSIBLE_GENDERS = %w(male female other).freeze

  belongs_to :user

  validates_presence_of :user, :first_name, :last_name, :gender, :birth_date, :street_name, :zip_code, :city, :state, :country
  validate :birthdate_not_in_future
  validates_inclusion_of :gender, in: POSSIBLE_GENDERS

  # Returns true if the user is 18 years old or older
  #
  # @param none
  # @return [Boolean] whether the user is an adult
  def adult?
    birth_date.in_time_zone <= 18.years.ago
  end

  # Returns the age of the user based on the current date
  #
  # @param none
  # @return [Int] for age as number of years
  def age
    age_at_time(Time.zone.now)
  end

  # Returns the age of the user based on the given date
  #
  # @param none
  # @return [Int] for age as number of years
  def age_at_time(given_date)
    given_date_is_before_birth_date = given_date.month > birth_date.month || (given_date.month == birth_date.month && given_date.day >= birth_date.day)
    given_date.year - birth_date.year - (given_date_is_before_birth_date ? 0 : 1)
  end

  # Returns the Full Name of the user
  #
  # @param none
  # @return [String] of name
  def name
    first_name + ' ' + last_name
  end

  # Returns the address of the user
  # in Format: Street, Zip-Code City, State, Country
  #
  # @param none
  # @return [String] of address
  def address
    street_name + ', ' + zip_code + ' ' + city + ', ' + state + ', ' + country
  end

  # Returns a list of allowed parameters.
  #
  # @param none
  # @return [Symbol] List of parameters
  def self.allowed_params
    %i(first_name last_name gender birth_date street_name zip_code city state country discovery_of_site)
  end

  # Returns an array containing the allowed methods to sort by
  #
  # @param none
  # @return [Symbol] List of methods
  def self.allowed_sort_methods
    Profile.allowed_params + %i(address name age)
  end

  private

  def birthdate_not_in_future
    if birth_date.present? && birth_date.in_time_zone > Date.current
      errors.add(:birth_date, I18n.t('profiles.validation.birthday_in_future'))
    end
  end
end
