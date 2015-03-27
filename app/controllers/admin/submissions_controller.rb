class Admin::SubmissionsController < ApplicationController

  before_filter :require_login
  
  #load_and_authorize_resource
  
  
  def new
    authorize! :new, :submissions
    
  end

  def create
  
    authorize! :create, :submissions
  
    uploaded_io = params[:upload]
    #The object in the params hash is an instance of a subclass of IO.
    #Depending on the size of the uploaded file it may in fact be a StringIO
    #or an instance of File backed by a temporary file. In both cases 
    #the object will have an original_filename attribute containing the 
    #name the file had on the user's computer and a content_type attribute 
    #containing the MIME type of the uploaded file
    File.open(Rails.root.join('public', 'uploaded_mzid_files', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
    end
  end
  #Here the file is uploaded but the MzidFile object (model) is not saved- To do that admin user
  respond_to do |format|
    format.js { 
       
      render :layout => false 
    }
  end
   
   #redirect_to :back
  
  
end


#~ function check_file(){
                #~ str=document.getElementById('fileToUpload').value.toUpperCase();
        #~ suffix=".JPG";
        #~ suffix2=".JPEG";
        #~ if(str.indexOf(suffix, str.length - suffix.length) == -1||
                       #~ str.indexOf(suffix2, str.length - suffix2.length) == -1){
        #~ alert('File type not allowed,\nAllowed file: *.jpg,*.jpeg');
            #~ document.getElementById('fileToUpload').value='';
       #~ }
       #~ 
#~ }



#~ $(function() {
  #~ $('#loading-indicator').hide();  // hide it initially.
  #~ $(document)  
    #~ .ajaxStart(function() {
      #~ $('#loading-indicator').show(); // show on any Ajax event.
    #~ })
    #~ .ajaxStop(function() {
      #~ $('#loading-indicator').hide(); // hide it when it is done.
  #~ });
#~ });
