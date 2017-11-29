# Handles incoming user account HTTP JSON web service requests
# @author Chris Loftus
class API::UsersController < API::ApplicationController
  include UsersCommon

  before_action :set_current_page, except: [:index]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :admin_required, only: [:index, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :show_record_not_found

  def search
    # Use will_paginate's :conditions and :joins to search across both the
    # users and user_details tables. search_fields private method will add a field
    # for each checkbox field checked by the user, or returns nil
    # if none were checked. The search_conditions method is defined
    # in lib/searchable.rb and either searches across all columns identified in
    # User.searchable_by or uses the search_fields to constrain the search

    respond_to do |format|
      # Deal with incoming Ajax request for JSON data for autocomplete search field
      format.json {
        @users = User.where(User.search_conditions(params[:q], search_fields(User)))
                     .joins(:user_detail)
                     .order('surname, firstname')
        puts "Users are #{@users.join(' ')}"
      }
    end
  end


  # GET /api/users.json
  def index
    # If the REST client wants everything using the all query
    # parameter, then give it everything!
    if params.key?(:all)
      @users = User.all.order('surname, firstname')
    else
      @users = User.paginate(page: params[:page],
                             per_page: params[:per_page])
                   .order('surname, firstname')
    end
  end

  # GET /api/users/1.json
  def show
    if current_user.id == @user.id || is_admin?
      respond_to do |format|
        format.json
      end
    else
      indicate_illegal_request I18n.t('users.not-your-account')
    end
  end

  # POST /api/users.json
  def create
    respond_to do |format|
      format.json do
        @user = User.new(user_params)
        user_detail = UserDetail.new(user_detail_params)
        @user.user_detail = user_detail

        # Only create a new image if the :image_file parameter
        # was specified
        @image = Image.new(photo: params[:image_file]) if params[:image_file]

        # The ImageService model wraps up application logic to
        # handle saving images correctly
        @service = ImageService.new(@user, @image)

        if @service.save # Will attempt to save user and image
          head :created, location: api_user_url(@user)
        else
          render json: @user.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /api/users/1.json
  def update
    if current_user.id == @user.id || is_admin?
      respond_to do |format|
        format.json do
          @image = @user.image
          @service = ImageService.new(@user, @image)
          if @service.update_attributes(user_params, params[:image_file])
            head :created
          else
            render json: @user.errors, status: :unprocessable_entity
          end
        end
      end
    else
      indicate_illegal_request I18n.t('users.not-your-account')
    end
  end

  # DELETE /api/users/1.json
  def destroy
    respond_to do |format|
      format.json do
        @user.destroy
        head :no_content
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.


  def indicate_illegal_request(message)
    respond_to do |format|
      format.json {
        render json: "{#{message}}",
               status: :unprocessable_entity
      }
    end
  end

  def show_record_not_found(exception)
    respond_to do |format|
      format.json {
        render json: '{Account no longer exists.}',
               status: :unprocessable_entity
      }
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # Note that the user_details_attributes call used in the non-API UsersController
  # class did not work for REST client requests. It may be that nested attributes
  # as supported by the nested_attributes call in the User model may not work
  # with non-form based requests. Further investigation is required. Consequently,
  # the data is sent in a unnested form and the objects created and tied
  # together explicitly in the create action.
  def user_params
    params.require(:user).permit(:surname, :firstname, :phone, :grad_year, :jobs, :email)
  end

  def user_detail_params
    params.require(:user_detail).permit(:login, :password, :password_confirmation)
  end

end
