class RequestsController < ApplicationController
  load_and_authorize_resource
  skip_authorize_resource only: %i(new create)
  before_action :set_request, only: %i(show edit update destroy accept)

  # GET /requests
  def index
    authorize! :index, Request
    @requests = Request.all
  end

  # GET /requests/1
  def show; end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit; end

  # POST /requests
  def create
    @request = Request.new(request_params)
    if @request.save
      Mailer.send_generic_email(false, @request.email, Rails.configuration.reply_to_address, I18n.t('requests.email.topic'),
                                I18n.t('requests.email.content'))
      redirect_to root_path, notice: I18n.t('requests.notice.was_created')
    else
      render :new
    end
  end

  # PATCH/PUT /requests/1
  def update
    if @request.update(request_params)
      redirect_to @request, notice: I18n.t('requests.notice.was_updated')
    else
      render :edit
    end
  end

  def set_contact_person
    @request = Request.find(params[:request_id])
    update_params = contact_person_params
    if !update_params[:contact_person].empty? && @request.update(update_params)
      redirect_to @request, notice: I18n.t('requests.notice.was_updated')
    else
      render :show
    end
  end

  def set_notes
    @request = Request.find(params[:request_id])
    update_params = notes_params
    if !update_params[:notes].empty? && @request.update(update_params)
      redirect_to @request, notice: I18n.t('requests.notice.was_updated')
    else
      render :show
    end
  end

  # DELETE /requests/1
  def destroy
    @request.destroy
    redirect_to requests_url, notice: I18n.t('requests.notice.was_deleted')
  end

  def accept
    authorize! :change_status, @request
    @request.status = :accepted
    @request.save!
    redirect_to @request, notice: I18n.t('requests.notice.was_accepted')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_request
    @request = Request.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def request_params
    params.require(:request).permit(:form_of_address,
                                    :first_name,
                                    :last_name,
                                    :phone_number,
                                    :school_street,
                                    :school_zip_code_city,
                                    :topic_of_workshop,
                                    :time_period,
                                    :email,
                                    :number_of_participants,
                                    :knowledge_level,
                                    :annotations,
                                    :grade)
  end

  def contact_person_params
    params.require(:request).permit(:contact_person)
  end

  def notes_params
    params.require(:request).permit(:notes)
  end
end
