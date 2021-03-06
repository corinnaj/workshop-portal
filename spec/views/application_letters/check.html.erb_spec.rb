require 'rails_helper'

RSpec.describe "application_letters/check", type: :view do

  before(:each) do
    @application_letter = assign(:application_letter, FactoryGirl.create(:application_letter))
  end

  it "should show an upload form for an agreement letter for profiles with an age of <18 and accepted application" do
    @user = FactoryGirl.create(:user_with_profile)
    event = FactoryGirl.create(:event)
    @application_letter = FactoryGirl.create(:application_letter, status: :accepted, user: @user, event: event)
    event.application_deadline = Date.yesterday
    event.acceptances_have_been_sent = true
    assign(:application_letter, @application_letter)
    render
    expect(rendered).to have_selector("input[type='file']")
    expect(rendered).to have_selector("input[type='submit']")
    expect(rendered).to have_text(I18n.t('agreement_letters.agreement_letter'))
  end

  it "should not show an upload form for an agreement letter without accepted application" do
    @user = FactoryGirl.create(:user_with_profile)
    event = FactoryGirl.create(:event)
    @application_letter = FactoryGirl.create(:application_letter, user: @user, event: event)
    assign(:application_letter, @application_letter)
    render
    expect(rendered).not_to have_selector("input[type='file']")
    expect(rendered).not_to have_selector("input[type='submit']")
    expect(rendered).not_to have_text(I18n.t('agreement_letters.agreement_letter'))
  end  

  context "independent of deadline exceeded or not" do
    before(:each) do
      assign(:application_deadline_exceeded, @application_letter.after_deadline?)
      render
    end

    it "has correct headline" do
      expect(rendered).to have_css('h1', text: I18n.t('application_letters.check.check_application_for', event_name: @application_letter.event.name))
    end

    it "renders application's attributes" do
      expect(rendered).to have_css('h3', text: I18n.t('application_letters.check.my_application'))
      expect(rendered).to have_text(@application_letter.motivation)
      expect(rendered).to have_text(@application_letter.emergency_number)
      expect(rendered).to have_text(@application_letter.organisation)
      expect(rendered).to have_text(@application_letter.allergies)
      expect(rendered).to have_text(@application_letter.annotation)
      expect(rendered).to have_text(@application_letter.eating_habits.join(', '))
      @application_letter.event.custom_application_fields
        .zip(@application_letter.custom_application_fields)
        .each do |field_name, field_value|
          expect(rendered).to have_text("#{field_name}: #{field_value}")
        end
    end

    it "renders applicant's attributes" do
      expect(rendered).to have_css('h3', text: I18n.t('application_letters.check.my_personal_data'))
      expect(rendered).to have_text(@application_letter.user.profile.name)
      expect(rendered).to have_text(I18n.t('profiles.genders.' + @application_letter.user.profile.gender))
      expect(rendered).to have_text(I18n.l(@application_letter.user.profile.birth_date))
      expect(rendered).to have_text(@application_letter.user.profile.address)
    end

    it "renders link to edit profile" do
      expect(rendered).to have_link(id: 'edit_profile_link', href: edit_profile_path(@application_letter.user.profile))
    end
  end

  context "with application deadline exceeded" do
    before(:each) do
      assign(:application_deadline_exceeded, true)
      render
    end
    it "renders information concerning application deadline" do
      expect(rendered).to have_text(I18n.t('application_letters.check.deadline_exceeded'))
    end

    it "doesnt render link to edit application" do
      expect(rendered).to_not have_link(I18n.t("helpers.links.edit"), id: 'edit_application_link', href: edit_application_letter_path(@application_letter))
    end
  end

  context "with application deadline not exceeded" do
    before(:each) do
      assign(:application_deadline_exceeded, false)
      render
    end
    it "renders information concerning application deadline" do
      expect(rendered).to have_text(I18n.t('application_letters.check.can_change_until', application_deadline: I18n.l(@application_letter.event.application_deadline)))
    end

    it "renders link to edit application" do
      expect(rendered).to have_link(id: 'edit_application_link', href: edit_application_letter_path(@application_letter))
    end
  end
end
