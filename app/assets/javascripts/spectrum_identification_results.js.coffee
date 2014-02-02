# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
 
#ready = -> 

$ -> 
  $("#sir_table").dataTable
    sPaginationType: "full_numbers"
    bProcessing: true
    bServerSide: true
    sAjaxSource: $('#sir_table').data('source')



# Note that if I use the "click" function on ".sii_link" like so:
#$ ->
#  $('a[data-sii-id]').click ->
# it does not trigger the js, since sii_link is not yet in the DOM, it is created ajaxy
#Remember that $ -> makes JQuery run the function on DOMContentLoaded
#And if I, instead, use:
#$ ->
#  $('#sii_table').on "click", ".sii_link", (e) ->
#the "on" function triggers an html response:
#In the network tab in chrome console, I see every time a click a sii_link two responses are triggered:
#one html and one (JS)
#I think it may need to trigger this additional html so the "on" funciton can parse the new ajax-created sii_link DOM node

#See delegated events : http://api.jquery.com/on/
#Delegated events have the advantage that they can process events from descendant elements that are added to the document at a later time

#this function, in show.js.erb works bad. Only for 2nd click and subsequents. Por que? No se sabe
$ ->
  $("#sir_table").on "click", ".sir_link", ()  ->
    $("#sir_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")
    $("#spectrum").empty()
    $("#peptide_sequence").remove()
    $("#sii_cvp td.empty").empty()

      
$ ->  
  $('#sii_table').on "click", ".sii_link", (e) -> 
  #this function is bound to all ".sii_link" click events, even if they are added to the DOM via ajax later
    sii_id = $(this).data("sii-id")

    $("#sii_table .flat_link").removeClass("flat_link")
    $(this).addClass("flat_link")

    $("#spectrum").empty()
    
    $("#peptide_sequence").remove()
    $("#spectrum").before("<div id=peptide_sequence class=spectrum_annotation>")
    

    d3.json "results/sir_id/identification_item?sii_id=" + sii_id + "", (error, json) ->
      $("#spectrum").css("visibility", "visible") 
      return console.warn(error) if error
      if $.isEmptyObject json
        missing_spec_msg = "<div class=spectrum_display_msg><p>NO FRAGMENTATION AVAILABLE FOR SELECTED SPECTRUM IDENTIFICATION ITEM</p></div>"
        $("#spectrum").append(missing_spec_msg)
      else
        visualizeD3spectrum json
    #e.preventDefault()


#visualizeD3spectrum = (json) ->
$ -> 

  #jsonFragmentIons = json
  jsonFragmentIons = [{"id":3579,"spectrum_identification_item_id":27742,"charge":1,"index":5,"m_mz":447.217,"m_intensity":4380000,"m_error":-0.0031,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3580,"spectrum_identification_item_id":27742,"charge":1,"index":6,"m_mz":576.262,"m_intensity":854900,"m_error":-0.0008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3581,"spectrum_identification_item_id":27742,"charge":1,"index":7,"m_mz":762.389,"m_intensity":7506000,"m_error":0.0478,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3582,"spectrum_identification_item_id":27742,"charge":1,"index":11,"m_mz":1230.61,"m_intensity":30210000,"m_error":-0.003,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3583,"spectrum_identification_item_id":27742,"charge":1,"index":12,"m_mz":1344.65,"m_intensity":12170000,"m_error":-0.0026,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3584,"spectrum_identification_item_id":27742,"charge":1,"index":15,"m_mz":1686.82,"m_intensity":11670000,"m_error":-0.003,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3585,"spectrum_identification_item_id":27742,"charge":1,"index":17,"m_mz":1913.98,"m_intensity":9618000,"m_error":-0.005,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3586,"spectrum_identification_item_id":27742,"charge":1,"index":21,"m_mz":2342.17,"m_intensity":10810000,"m_error":-0.0048,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3587,"spectrum_identification_item_id":27742,"charge":1,"index":22,"m_mz":2413.21,"m_intensity":8991000,"m_error":-0.0067,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3588,"spectrum_identification_item_id":27742,"charge":1,"index":23,"m_mz":2470.23,"m_intensity":15620000,"m_error":-0.0059,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3589,"spectrum_identification_item_id":27742,"charge":1,"index":24,"m_mz":2607.28,"m_intensity":5489000,"m_error":-0.0101,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3590,"spectrum_identification_item_id":27742,"charge":1,"index":26,"m_mz":2792.37,"m_intensity":13310000,"m_error":-0.0042,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3591,"spectrum_identification_item_id":27742,"charge":1,"index":27,"m_mz":2921.41,"m_intensity":21520000,"m_error":-0.0045,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3592,"spectrum_identification_item_id":27742,"charge":1,"index":30,"m_mz":3246.65,"m_intensity":31540000,"m_error":-0.0077,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3593,"spectrum_identification_item_id":27742,"charge":1,"index":31,"m_mz":3402.75,"m_intensity":19790000,"m_error":-0.0073,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3594,"spectrum_identification_item_id":27742,"charge":1,"index":33,"m_mz":3662.9,"m_intensity":5384000,"m_error":-0.011,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3595,"spectrum_identification_item_id":27742,"charge":1,"index":34,"m_mz":3763.95,"m_intensity":9486000,"m_error":-0.009,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3596,"spectrum_identification_item_id":27742,"charge":1,"index":35,"m_mz":3820.97,"m_intensity":12940000,"m_error":-0.008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3597,"spectrum_identification_item_id":27742,"charge":1,"index":38,"m_mz":4184.12,"m_intensity":28610000,"m_error":-0.0084,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3598,"spectrum_identification_item_id":27742,"charge":1,"index":39,"m_mz":4285.17,"m_intensity":8175000,"m_error":-0.0094,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3599,"spectrum_identification_item_id":27742,"charge":1,"index":40,"m_mz":4398.25,"m_intensity":24870000,"m_error":-0.0082,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3600,"spectrum_identification_item_id":27742,"charge":1,"index":41,"m_mz":4527.3,"m_intensity":46070000,"m_error":-0.0097,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3601,"spectrum_identification_item_id":27742,"charge":1,"index":42,"m_mz":4655.39,"m_intensity":10500000,"m_error":-0.0066,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3602,"spectrum_identification_item_id":27742,"charge":1,"index":43,"m_mz":4802.46,"m_intensity":46930000,"m_error":-0.0092,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3603,"spectrum_identification_item_id":27742,"charge":1,"index":44,"m_mz":4917.49,"m_intensity":19710000,"m_error":-0.009,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3604,"spectrum_identification_item_id":27742,"charge":1,"index":45,"m_mz":5045.58,"m_intensity":22930000,"m_error":-0.01,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3605,"spectrum_identification_item_id":27742,"charge":1,"index":46,"m_mz":5192.65,"m_intensity":31270000,"m_error":-0.0107,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3606,"spectrum_identification_item_id":27742,"charge":1,"index":47,"m_mz":5320.74,"m_intensity":10140000,"m_error":-0.0099,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3607,"spectrum_identification_item_id":27742,"charge":1,"index":48,"m_mz":5457.79,"m_intensity":5954000,"m_error":-0.0204,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3608,"spectrum_identification_item_id":27742,"charge":1,"index":50,"m_mz":5698.98,"m_intensity":7813000,"m_error":-0.0127,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3609,"spectrum_identification_item_id":27742,"charge":1,"index":51,"m_mz":5800.03,"m_intensity":17080000,"m_error":-0.0128,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3610,"spectrum_identification_item_id":27742,"charge":1,"index":52,"m_mz":5929.07,"m_intensity":9987000,"m_error":-0.0147,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3611,"spectrum_identification_item_id":27742,"charge":1,"index":53,"m_mz":6000.11,"m_intensity":16830000,"m_error":-0.0128,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3612,"spectrum_identification_item_id":27742,"charge":1,"index":54,"m_mz":6129.15,"m_intensity":35420000,"m_error":-0.0105,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3613,"spectrum_identification_item_id":27742,"charge":1,"index":55,"m_mz":6260.19,"m_intensity":14530000,"m_error":-0.0126,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3614,"spectrum_identification_item_id":27742,"charge":1,"index":56,"m_mz":6388.29,"m_intensity":5249000,"m_error":-0.008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3615,"spectrum_identification_item_id":27742,"charge":1,"index":59,"m_mz":6675.4,"m_intensity":56680000,"m_error":-0.0142,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3616,"spectrum_identification_item_id":27742,"charge":1,"index":61,"m_mz":6903.51,"m_intensity":13460000,"m_error":-0.0141,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3617,"spectrum_identification_item_id":27742,"charge":1,"index":62,"m_mz":7031.61,"m_intensity":14780000,"m_error":-0.0075,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3618,"spectrum_identification_item_id":27742,"charge":1,"index":65,"m_mz":7353.77,"m_intensity":17410000,"m_error":-0.0175,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3619,"spectrum_identification_item_id":27742,"charge":1,"index":69,"m_mz":7766.04,"m_intensity":5084000,"m_error":-0.0168,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3620,"spectrum_identification_item_id":27742,"charge":1,"index":73,"m_mz":8108.23,"m_intensity":8978000,"m_error":-0.0192,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3621,"spectrum_identification_item_id":27742,"charge":1,"index":76,"m_mz":8391.42,"m_intensity":8186000,"m_error":-0.0171,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3622,"spectrum_identification_item_id":27742,"charge":1,"index":78,"m_mz":8647.61,"m_intensity":7804000,"m_error":-0.0172,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3623,"spectrum_identification_item_id":27742,"charge":1,"index":83,"m_mz":9235.89,"m_intensity":7299000,"m_error":-0.0189,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3624,"spectrum_identification_item_id":27742,"charge":1,"index":86,"m_mz":9549.05,"m_intensity":22380000,"m_error":-0.0188,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3625,"spectrum_identification_item_id":27742,"charge":1,"index":96,"m_mz":10610.6,"m_intensity":6606000,"m_error":-0.0238,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},{"id":3626,"spectrum_identification_item_id":27742,"charge":1,"index":51,"m_mz":5632.88,"m_intensity":36810000,"m_error":0.0075,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},{"id":3627,"spectrum_identification_item_id":27742,"charge":1,"index":21,"m_mz":2411.3,"m_intensity":24380000,"m_error":-0.0042,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},{"id":3628,"spectrum_identification_item_id":27742,"charge":1,"index":5,"m_mz":521.271,"m_intensity":649000,"m_error":-0.0008,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},{"id":3629,"spectrum_identification_item_id":27742,"charge":1,"index":94,"m_mz":10268.6,"m_intensity":9812000,"m_error":-0.0121,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3630,"spectrum_identification_item_id":27742,"charge":1,"index":91,"m_mz":9912.36,"m_intensity":8134000,"m_error":-0.0102,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3631,"spectrum_identification_item_id":27742,"charge":1,"index":80,"m_mz":8835.72,"m_intensity":10730000,"m_error":-0.0166,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3632,"spectrum_identification_item_id":27742,"charge":1,"index":76,"m_mz":8424.44,"m_intensity":10510000,"m_error":-0.0151,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3633,"spectrum_identification_item_id":27742,"charge":1,"index":75,"m_mz":8296.36,"m_intensity":5402000,"m_error":0.002,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3634,"spectrum_identification_item_id":27742,"charge":1,"index":70,"m_mz":7708.07,"m_intensity":13600000,"m_error":-0.0124,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3635,"spectrum_identification_item_id":27742,"charge":1,"index":68,"m_mz":7507.99,"m_intensity":8495000,"m_error":-0.0161,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3636,"spectrum_identification_item_id":27742,"charge":1,"index":67,"m_mz":7394.91,"m_intensity":18550000,"m_error":-0.0116,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3637,"spectrum_identification_item_id":27742,"charge":1,"index":60,"m_mz":6633.49,"m_intensity":25800000,"m_error":-0.0088,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3638,"spectrum_identification_item_id":27742,"charge":1,"index":57,"m_mz":6333.31,"m_intensity":49330000,"m_error":-0.0102,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3639,"spectrum_identification_item_id":27742,"charge":1,"index":55,"m_mz":6068.15,"m_intensity":20890000,"m_error":-0.0137,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3640,"spectrum_identification_item_id":27742,"charge":1,"index":49,"m_mz":5340.69,"m_intensity":33270000,"m_error":-0.0103,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3641,"spectrum_identification_item_id":27742,"charge":1,"index":48,"m_mz":5211.64,"m_intensity":27820000,"m_error":-0.0218,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3642,"spectrum_identification_item_id":27742,"charge":1,"index":45,"m_mz":4864.47,"m_intensity":11600000,"m_error":-0.0085,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3643,"spectrum_identification_item_id":27742,"charge":1,"index":44,"m_mz":4749.44,"m_intensity":16220000,"m_error":-0.0076,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3644,"spectrum_identification_item_id":27742,"charge":1,"index":40,"m_mz":4315.17,"m_intensity":5914000,"m_error":-0.0109,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3645,"spectrum_identification_item_id":27742,"charge":1,"index":38,"m_mz":4103.02,"m_intensity":9840000,"m_error":-0.0083,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3646,"spectrum_identification_item_id":27742,"charge":1,"index":37,"m_mz":3965.97,"m_intensity":23390000,"m_error":-0.007,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3647,"spectrum_identification_item_id":27742,"charge":1,"index":36,"m_mz":3878.93,"m_intensity":4996000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3648,"spectrum_identification_item_id":27742,"charge":1,"index":32,"m_mz":3459.71,"m_intensity":21840000,"m_error":-0.0048,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3649,"spectrum_identification_item_id":27742,"charge":1,"index":28,"m_mz":3069.55,"m_intensity":8877000,"m_error":-0.0072,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3650,"spectrum_identification_item_id":27742,"charge":1,"index":27,"m_mz":2954.53,"m_intensity":21940000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3651,"spectrum_identification_item_id":27742,"charge":1,"index":25,"m_mz":2755.43,"m_intensity":17380000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3652,"spectrum_identification_item_id":27742,"charge":1,"index":24,"m_mz":2698.41,"m_intensity":20280000,"m_error":-0.0052,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3653,"spectrum_identification_item_id":27742,"charge":1,"index":22,"m_mz":2496.33,"m_intensity":7171000,"m_error":-0.0041,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3654,"spectrum_identification_item_id":27742,"charge":1,"index":18,"m_mz":2083.07,"m_intensity":29990000,"m_error":-0.0043,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3655,"spectrum_identification_item_id":27742,"charge":1,"index":17,"m_mz":1954.03,"m_intensity":11550000,"m_error":-0.0037,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3656,"spectrum_identification_item_id":27742,"charge":1,"index":14,"m_mz":1537.77,"m_intensity":6256000,"m_error":-0.0023,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3657,"spectrum_identification_item_id":27742,"charge":1,"index":13,"m_mz":1423.73,"m_intensity":7062000,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3658,"spectrum_identification_item_id":27742,"charge":1,"index":12,"m_mz":1308.71,"m_intensity":6381000,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3659,"spectrum_identification_item_id":27742,"charge":1,"index":11,"m_mz":1195.62,"m_intensity":972500,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3660,"spectrum_identification_item_id":27742,"charge":1,"index":10,"m_mz":1124.58,"m_intensity":1199000,"m_error":-0.0015,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3661,"spectrum_identification_item_id":27742,"charge":1,"index":9,"m_mz":1053.55,"m_intensity":2309000,"m_error":0.003,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3662,"spectrum_identification_item_id":27742,"charge":1,"index":7,"m_mz":762.389,"m_intensity":7506000,"m_error":-0.0012,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3663,"spectrum_identification_item_id":27742,"charge":1,"index":5,"m_mz":505.253,"m_intensity":810600,"m_error":-0.0005,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},{"id":3664,"spectrum_identification_item_id":27742,"charge":1,"index":107,"m_mz":11752.3,"m_intensity":4613000,"m_error":-0.02,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"},{"id":3665,"spectrum_identification_item_id":27742,"charge":1,"index":50,"m_mz":5454.78,"m_intensity":11680000,"m_error":-0.0154,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"},{"id":3666,"spectrum_identification_item_id":27742,"charge":1,"index":44,"m_mz":4750.44,"m_intensity":4836000,"m_error":-0.015,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"}]

  i = 0
  while i < jsonFragmentIons.length
    if jsonFragmentIons[i].fragment_type.match(/precursor/)
      jsonFragmentIons[i].color = "darkgray"
    else if jsonFragmentIons[i].fragment_type.match(/frag: a/)
      jsonFragmentIons[i].color = "crimson"
    else if jsonFragmentIons[i].fragment_type.match(/frag: b/)
      jsonFragmentIons[i].color = "orangered"  
    else if jsonFragmentIons[i].fragment_type.match(/frag: c/)
      jsonFragmentIons[i].color = "darkorange"
    else if jsonFragmentIons[i].fragment_type.match(/frag: x/) 
     jsonFragmentIons[i].color = "teal" 
    else if jsonFragmentIons[i].fragment_type.match(/frag: y/)
     jsonFragmentIons[i].color = "royalblue"
    else if jsonFragmentIons[i].fragment_type.match(/frag: z/)
      jsonFragmentIons[i].color = "navy"
    else 
      jsonFragmentIons[i].color = "black"
    i++


  #SET UP svgContainer--------------------------------------------
  #---------------------------------------------------------------
  w = 600
  h = 280
  padding = 40
  #svgContainer = d3.select("#spectrum").append("svg")
  svgContainer = d3.select("#spectrum_test").append("svg")
                                     .attr("width", w)
                                     .attr("height", h)
                                     

  #SCALING thing--------------------------------------------------
  #---------------------------------------------------------------
  maxInitialMz = d3.max(jsonFragmentIons, (d) -> return d.m_mz)
  minInitialMz = d3.min(jsonFragmentIons, (d) -> return d.m_mz)  
  maxInitialIntensity = d3.max(jsonFragmentIons, (d) -> return d.m_intensity)
  minInitialIntensity = d3.min(jsonFragmentIons, (d) -> return d.m_intensity)
  
  xScale = d3.scale.linear() #Remember: When I say “input,” you say “domain.” Then I say “output,” and you say “range.” Ready?
                   .domain([minInitialMz, maxInitialMz])
                   .range([padding, w - padding]) 

  yScale = d3.scale.linear()
                   .domain([minInitialIntensity, maxInitialIntensity])
                   #.range([padding, h - padding])  #Now that we’re using scales, it’s super easy to reverse that, so greater values are higher up, as you would expect (alignedleft/scales)
                   .range([h - padding, padding])

  #SET UP Axis----------------------------------------------------
  xAxis = d3.svg.axis()
                 .scale(xScale)
                 .orient("bottom")
                 .ticks(5)

  yAxis = d3.svg.axis()
                 .scale(yScale)
                 .orient("left")
                 .ticks(5)
                 .tickFormat("")
                 
  
  #APEND, Axis, MS BARS , etc To svgContainer --------------------  
  svgContainer.append("g")
               .attr("class", "x axis")
               .attr("transform", "translate(0," + (h - padding) + ")")
               .call(xAxis)

  svgContainer.append("g")
               .attr("class", "y axis")
               .attr("transform", "translate(" + padding  + ",0)")
               .call(yAxis)
              
  svgContainer.append("text")
               .attr("class", "xAxisLabel")
               .attr("text-anchor", "end")
               .attr("x", w - padding)
               .attr("y", h - 10)
               .text("m / z")
               .attr("font-family", "sans-serif")
               .attr("font-size", "12px")
               

  msBars = svgContainer.selectAll('line.matched_peak')   
                        .data(jsonFragmentIons)
                        .enter()
                        .append("line")
                        .attr("class", "matched_peak")
                        .attr("x1", (d) -> return xScale(d.m_mz) )
                        .attr("y1", h - padding)
                        .attr("x2", (d) -> return xScale(d.m_mz) )
                        .attr("y2", (d) -> return  yScale(d.m_intensity) )
                        .attr("stroke-width", 1)
                        .attr("stroke", (d) -> return d.color)
                        .attr("fill")
                        

  msBarText = svgContainer.selectAll("text.matched_peak_label") #note I have to add class name, w/o it I would select DOM elements that the axis component added  From SO: "The problem is that you're drawing the axes before adding the lines and labels. By doing .selectAll("line") and .selectAll("text"), you're selecting the existing DOM elements that the axis component added. Then you're matching data to it and therefore your .enter() selection doesn't contain what you suppose."
                           .data(jsonFragmentIons)
                           .enter()
                           .append("text")
                           .attr("class", "matched_peak_label")
                           .attr("x", (d) -> return xScale(d.m_mz) )
                           .attr("y", (d) -> return yScale(d.m_intensity) )                     
                           .text((d) -> return d.fragment_type.substr(5)) #substr removes the "frag: " part
                           #.attr("transform", (d) -> return "rotate(90)" )
                           .attr("font-family", "sans-serif")
                           .attr("font-size", "9px")
                           #.attr("cursor", "pointer")
                           .attr("fill", "gray")


  #TOOLTIPS. 2 OPTIONS:
  #---------------------------------------------------------------
  #1 HTML div tooltips--------------
  #msBarTextLabels.on("mouseover", (d) ->  
  #  #Get this bar's x/y values, then augment for the tooltip
  #  xPosition = parseFloat(d3.select(this).attr("x")) #+ 300 #OJO No puedo usar rangeBand porque esa es una propiedad de las escalas ordinales !!+ xScale.rangeBand() / 2
  #  yPosition = parseFloat(d3.select(this).attr("y")) 
  #  #Update the tooltip position and value
  #  d3.select("#tooltip")
  #    .style("left", xPosition + "px")
  #    .style("top", yPosition + "px")
  #    .select("#value")
  #    .html(d.fragment_type + '<br/>z: ' + d.charge + '<br/>m/z: ' + d.m_mz + '<br/>intensity: ' + d.m_intensity + '<br/>error: ' + d.m_error)
  #  #Show the tooltip
  #  d3.select("#tooltip").classed("hidden", false)
  #
  #).on("mouseout",  (d) -> d3.select("#tooltip").classed("hidden",true) )

  #2 jquery plugin tipsy-------------- Include //= require jquery.tipsy in application.js
  $("svg line").tipsy
    gravity: "n"
    offset: 1
    html: true
    title: ->
      d = @__data__
      #c = colors(d.i)
      d.fragment_type + '<br/>z: ' + d.charge + '<br/>m/z: ' + d.m_mz + '<br/>intensity: ' + d.m_intensity + '<br/>error: ' + d.m_error
      
  #CHECKBOX Thing to filter (show only) checked ion types
  #d3.selectAll(".input class id").on "change", ->
  #  selected = this.name
  #  display = (if @checked then "inline" else "none")
    
  #  svgContainer.selectAll("line")
  #                                .filter( (d) -> d.fragment_type == selected )
  #                                .attr("display", display)
  
  
  zoomed = ->
    svgContainer.select(".x.axis").call xAxis
    svgContainer.select(".y.axis").call yAxis
    #svgContainer.select(".line.matched_peak").attr("d", msBars);
    svgContainer.selectAll(".line.matched_peak").attr("transform", "translate(" +
                  d3.event.translate[0] + ",0)scale(" + d3.event.scale + ", 1)");
    
  zoom = d3.behavior.zoom()
                     .x(xScale)
                     .y(yScale)
                     .scaleExtent([1, 10])
                     .on("zoom", zoomed)
  
  svgContainer.call zoom
  
  
  
#$(document).ready ready
#$(document).on "page:load", ready 

