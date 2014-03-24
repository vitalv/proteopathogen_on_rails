class AboutController < ApplicationController

  def index
  
  end
  
  def download_structure_sql
    send_file(
      "#{Rails.root}/public/structure.sql",
       filename: "proteopathogen_structure.sql",
       type: "text/x-sql"
    )
  end

  def download_structure_mwb
    send_file(
      "#{Rails.root}/public/proteopathogen.mwb",
       filename: "proteopathogen_structure.mwb",
    )
  end


end
