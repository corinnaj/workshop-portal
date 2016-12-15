require './db/sample_data/agreement_letters'
require './db/sample_data/application_letters'
require './db/sample_data/events'
require './db/sample_data/profiles'
require './db/sample_data/requests'
require './db/sample_data/users'

def add_sample_data
  events = Hash.new

  events[:programmierkurs] = event_programmierkurs
  events[:mintcamp] = event_mintcamp
  events[:bechersaeuberungsevent] = event_bechersaeuberungsevent
  events[:gongakrobatik] = event_gongakrobatik
  events[:batterie_akustik] = event_batterie_akustik
  events[:bachlorpodium] = event_bachlorpodium

  users = Hash.new
  users[:pupil] = user_pupil
  users[:teacher] = user_teacher
  users[:applicant] = user_applicant
  users[:tobi] = user_tobi
  users[:lisa] = user_lisa
  users[:max] = user_max
  users[:organizer] = user_organizer
  users[:coach] = user_coach

  profiles = Hash.new
  profiles[:pupil] = profile_pupil(users[:pupil])
  profiles[:teacher] = profile_teacher(users[:teacher])
  profiles[:applicant] = profile_applicant(users[:applicant])

  profiles[:tobi] = profile_tobi(users[:tobi])
  profiles[:tobi] = profile_tobi(users[:tobi])
  profiles[:lisa] = profile_lisa(users[:lisa])
  profiles[:max]  = profile_pupil_max(users[:max])
  profiles[:organizer] = profile_pupil_max(users[:organizer])
  profiles[:coach]  = profile_pupil_max(users[:coach])

  application_letters = Hash.new
  application_letters[:applicant_gongakrobatik] = application_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])
  application_letters[:applicant_programmierkurs_lisa] = application_letter_applicant_programmierkurs_1(users[:lisa], events[:programmierkurs])
  application_letters[:applicant_programmierkurs_max] = application_letter_applicant_programmierkurs_2(users[:max], events[:programmierkurs])
  application_letters[:applicant_programmierkurs_tobi] = application_letter_applicant_programmierkurs_3(users[:tobi], events[:programmierkurs])

  application_letters[:applicant_mintcamp_lisa] = application_letter_applicant_programmierkurs_1(users[:lisa], events[:mintcamp])
  application_letters[:applicant_mintcamp_max] = application_letter_applicant_programmierkurs_2(users[:max], events[:mintcamp])
  application_letters[:applicant_mintcamp_tobi] = application_letter_applicant_programmierkurs_3(users[:tobi], events[:mintcamp])

  requests = Hash.new
  requests[:hardware_entwicklung] = request_hardware_entwicklung(users[:teacher])

  agreement_letters = Hash.new
  agreement_letters[:applicant_gongakrobatik] = agreement_letter_applicant_gongakrobatik(users[:applicant], events[:gongakrobatik])

  [events, users, profiles, application_letters, requests, agreement_letters].each do |models|
    save_models(models)
  end
end

private
  def save_models(models)
    models.each do |key, model|
      model.save!
    end
  end
