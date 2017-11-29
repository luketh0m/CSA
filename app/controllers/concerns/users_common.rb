# Common shared code for the two UserController classes:
# human web one and API one. Trying to keep things a little DRY.
# @author Chris Loftus
module UsersCommon extend ActiveSupport::Concern
  
  def set_user
    @user = User.find(params[:id])
  end

  def set_current_page
    @current_page = params[:page] || 1
  end
  
  def search_fields(table)
    fields = []
    table.search_columns.each do |column|
      # The parameters have had the table name stripped off so we
      # have to to the same to each search_columns column
      fields << column if params[column.sub(/^.*\./, "")]
    end
    fields = nil unless fields.length > 0
    fields
  end

end
