# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#Note: I am placing this d3 thing here bc, since I am appending svg to content, I will see the results on all pages, and this (experiments.js) was empty of js.coffee

$ ->

  #dataset = [5, 10, 15, 20, 25]
  ##dataset = $("spectrum_identification").data
  #d3.select("content").selectAll("p")
    #.data(dataset)
    #.enter()  
    #.append("p")
    #.text( (d) ->  return d ) #javascript: .text(function(d) { return d; });

  jsonCircles = [
    { "x_axis": 30, "y_axis": 30, "radius": 20, "color" : "green" },
    { "x_axis": 110, "y_axis": 110, "radius": 20, "color" : "red"},
    { "x_axis": 70, "y_axis": 70, "radius": 20, "color" : "purple"}
  ]
  
  jsonRectangles = [
    { "x_axis": 30, "y_axis": 30, "width": 18,  "height":20, "color" : "green" },
    { "x_axis": 110, "y_axis": 110, "width": 22,  "height":18, "color" : "red"},
    { "x_axis": 450, "y_axis": 70, "width": 20,  "height":22, "color" : "purple"}
  ]
 
  ##SpectrumIdentificationItem.find(24337).fragments.where(fragment_type: "frag: y ion").to_json
  jsonFragmentIons = [
   {"id":181,"spectrum_identification_item_id":24337,"charge":1,"index":5,"m_mz":447.217,"m_intensity":4380000,"m_error":-0.0031,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":182,"spectrum_identification_item_id":24337,"charge":1,"index":6,"m_mz":576.262,"m_intensity":854900,"m_error":-0.0008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":183,"spectrum_identification_item_id":24337,"charge":1,"index":7,"m_mz":762.389,"m_intensity":7506000,"m_error":0.0478,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":184,"spectrum_identification_item_id":24337,"charge":1,"index":11,"m_mz":1230.61,"m_intensity":30210000,"m_error":-0.003,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":185,"spectrum_identification_item_id":24337,"charge":1,"index":12,"m_mz":1344.65,"m_intensity":12170000,"m_error":-0.0026,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":186,"spectrum_identification_item_id":24337,"charge":1,"index":15,"m_mz":1686.82,"m_intensity":11670000,"m_error":-0.003,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":187,"spectrum_identification_item_id":24337,"charge":1,"index":17,"m_mz":1913.98,"m_intensity":9618000,"m_error":-0.005,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":188,"spectrum_identification_item_id":24337,"charge":1,"index":21,"m_mz":2342.17,"m_intensity":10810000,"m_error":-0.0048,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":189,"spectrum_identification_item_id":24337,"charge":1,"index":22,"m_mz":2413.21,"m_intensity":8991000,"m_error":-0.0067,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":190,"spectrum_identification_item_id":24337,"charge":1,"index":23,"m_mz":2470.23,"m_intensity":15620000,"m_error":-0.0059,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":191,"spectrum_identification_item_id":24337,"charge":1,"index":24,"m_mz":2607.28,"m_intensity":5489000,"m_error":-0.0101,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":192,"spectrum_identification_item_id":24337,"charge":1,"index":26,"m_mz":2792.37,"m_intensity":13310000,"m_error":-0.0042,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":193,"spectrum_identification_item_id":24337,"charge":1,"index":27,"m_mz":2921.41,"m_intensity":21520000,"m_error":-0.0045,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":194,"spectrum_identification_item_id":24337,"charge":1,"index":30,"m_mz":3246.65,"m_intensity":31540000,"m_error":-0.0077,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":195,"spectrum_identification_item_id":24337,"charge":1,"index":31,"m_mz":3402.75,"m_intensity":19790000,"m_error":-0.0073,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":196,"spectrum_identification_item_id":24337,"charge":1,"index":33,"m_mz":3662.9,"m_intensity":5384000,"m_error":-0.011,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":197,"spectrum_identification_item_id":24337,"charge":1,"index":34,"m_mz":3763.95,"m_intensity":9486000,"m_error":-0.009,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":198,"spectrum_identification_item_id":24337,"charge":1,"index":35,"m_mz":3820.97,"m_intensity":12940000,"m_error":-0.008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":199,"spectrum_identification_item_id":24337,"charge":1,"index":38,"m_mz":4184.12,"m_intensity":28610000,"m_error":-0.0084,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":200,"spectrum_identification_item_id":24337,"charge":1,"index":39,"m_mz":4285.17,"m_intensity":8175000,"m_error":-0.0094,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":201,"spectrum_identification_item_id":24337,"charge":1,"index":40,"m_mz":4398.25,"m_intensity":24870000,"m_error":-0.0082,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":202,"spectrum_identification_item_id":24337,"charge":1,"index":41,"m_mz":4527.3,"m_intensity":46070000,"m_error":-0.0097,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":203,"spectrum_identification_item_id":24337,"charge":1,"index":42,"m_mz":4655.39,"m_intensity":10500000,"m_error":-0.0066,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":204,"spectrum_identification_item_id":24337,"charge":1,"index":43,"m_mz":4802.46,"m_intensity":46930000,"m_error":-0.0092,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":205,"spectrum_identification_item_id":24337,"charge":1,"index":44,"m_mz":4917.49,"m_intensity":19710000,"m_error":-0.009,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":206,"spectrum_identification_item_id":24337,"charge":1,"index":45,"m_mz":5045.58,"m_intensity":22930000,"m_error":-0.01,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":207,"spectrum_identification_item_id":24337,"charge":1,"index":46,"m_mz":5192.65,"m_intensity":31270000,"m_error":-0.0107,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":208,"spectrum_identification_item_id":24337,"charge":1,"index":47,"m_mz":5320.74,"m_intensity":10140000,"m_error":-0.0099,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":209,"spectrum_identification_item_id":24337,"charge":1,"index":48,"m_mz":5457.79,"m_intensity":5954000,"m_error":-0.0204,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":210,"spectrum_identification_item_id":24337,"charge":1,"index":50,"m_mz":5698.98,"m_intensity":7813000,"m_error":-0.0127,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":211,"spectrum_identification_item_id":24337,"charge":1,"index":51,"m_mz":5800.03,"m_intensity":17080000,"m_error":-0.0128,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":212,"spectrum_identification_item_id":24337,"charge":1,"index":52,"m_mz":5929.07,"m_intensity":9987000,"m_error":-0.0147,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":213,"spectrum_identification_item_id":24337,"charge":1,"index":53,"m_mz":6000.11,"m_intensity":16830000,"m_error":-0.0128,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":214,"spectrum_identification_item_id":24337,"charge":1,"index":54,"m_mz":6129.15,"m_intensity":35420000,"m_error":-0.0105,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":215,"spectrum_identification_item_id":24337,"charge":1,"index":55,"m_mz":6260.19,"m_intensity":14530000,"m_error":-0.0126,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":216,"spectrum_identification_item_id":24337,"charge":1,"index":56,"m_mz":6388.29,"m_intensity":5249000,"m_error":-0.008,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":217,"spectrum_identification_item_id":24337,"charge":1,"index":59,"m_mz":6675.4,"m_intensity":56680000,"m_error":-0.0142,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":218,"spectrum_identification_item_id":24337,"charge":1,"index":61,"m_mz":6903.51,"m_intensity":13460000,"m_error":-0.0141,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":219,"spectrum_identification_item_id":24337,"charge":1,"index":62,"m_mz":7031.61,"m_intensity":14780000,"m_error":-0.0075,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":220,"spectrum_identification_item_id":24337,"charge":1,"index":65,"m_mz":7353.77,"m_intensity":17410000,"m_error":-0.0175,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":221,"spectrum_identification_item_id":24337,"charge":1,"index":69,"m_mz":7766.04,"m_intensity":5084000,"m_error":-0.0168,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":222,"spectrum_identification_item_id":24337,"charge":1,"index":73,"m_mz":8108.23,"m_intensity":8978000,"m_error":-0.0192,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":223,"spectrum_identification_item_id":24337,"charge":1,"index":76,"m_mz":8391.42,"m_intensity":8186000,"m_error":-0.0171,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":224,"spectrum_identification_item_id":24337,"charge":1,"index":78,"m_mz":8647.61,"m_intensity":7804000,"m_error":-0.0172,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":225,"spectrum_identification_item_id":24337,"charge":1,"index":83,"m_mz":9235.89,"m_intensity":7299000,"m_error":-0.0189,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":226,"spectrum_identification_item_id":24337,"charge":1,"index":86,"m_mz":9549.05,"m_intensity":22380000,"m_error":-0.0188,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":227,"spectrum_identification_item_id":24337,"charge":1,"index":96,"m_mz":10610.6,"m_intensity":6606000,"m_error":-0.0238,"fragment_type":"frag: c ion","psi_ms_cv_fragment_type_accession":"MS:1001231"},
   {"id":228,"spectrum_identification_item_id":24337,"charge":1,"index":51,"m_mz":5632.88,"m_intensity":36810000,"m_error":0.0075,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},
   {"id":229,"spectrum_identification_item_id":24337,"charge":1,"index":21,"m_mz":2411.3,"m_intensity":24380000,"m_error":-0.0042,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},
   {"id":230,"spectrum_identification_item_id":24337,"charge":1,"index":5,"m_mz":521.271,"m_intensity":649000,"m_error":-0.0008,"fragment_type":"frag: y ion","psi_ms_cv_fragment_type_accession":"MS:1001220"},
   {"id":231,"spectrum_identification_item_id":24337,"charge":1,"index":94,"m_mz":10268.6,"m_intensity":9812000,"m_error":-0.0121,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":232,"spectrum_identification_item_id":24337,"charge":1,"index":91,"m_mz":9912.36,"m_intensity":8134000,"m_error":-0.0102,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":233,"spectrum_identification_item_id":24337,"charge":1,"index":80,"m_mz":8835.72,"m_intensity":10730000,"m_error":-0.0166,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":234,"spectrum_identification_item_id":24337,"charge":1,"index":76,"m_mz":8424.44,"m_intensity":10510000,"m_error":-0.0151,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":235,"spectrum_identification_item_id":24337,"charge":1,"index":75,"m_mz":8296.36,"m_intensity":5402000,"m_error":0.002,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":236,"spectrum_identification_item_id":24337,"charge":1,"index":70,"m_mz":7708.07,"m_intensity":13600000,"m_error":-0.0124,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":237,"spectrum_identification_item_id":24337,"charge":1,"index":68,"m_mz":7507.99,"m_intensity":8495000,"m_error":-0.0161,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":238,"spectrum_identification_item_id":24337,"charge":1,"index":67,"m_mz":7394.91,"m_intensity":18550000,"m_error":-0.0116,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":239,"spectrum_identification_item_id":24337,"charge":1,"index":60,"m_mz":6633.49,"m_intensity":25800000,"m_error":-0.0088,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":240,"spectrum_identification_item_id":24337,"charge":1,"index":57,"m_mz":6333.31,"m_intensity":49330000,"m_error":-0.0102,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":241,"spectrum_identification_item_id":24337,"charge":1,"index":55,"m_mz":6068.15,"m_intensity":20890000,"m_error":-0.0137,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":242,"spectrum_identification_item_id":24337,"charge":1,"index":49,"m_mz":5340.69,"m_intensity":33270000,"m_error":-0.0103,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":243,"spectrum_identification_item_id":24337,"charge":1,"index":48,"m_mz":5211.64,"m_intensity":27820000,"m_error":-0.0218,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":244,"spectrum_identification_item_id":24337,"charge":1,"index":45,"m_mz":4864.47,"m_intensity":11600000,"m_error":-0.0085,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":245,"spectrum_identification_item_id":24337,"charge":1,"index":44,"m_mz":4749.44,"m_intensity":16220000,"m_error":-0.0076,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":246,"spectrum_identification_item_id":24337,"charge":1,"index":40,"m_mz":4315.17,"m_intensity":5914000,"m_error":-0.0109,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":247,"spectrum_identification_item_id":24337,"charge":1,"index":38,"m_mz":4103.02,"m_intensity":9840000,"m_error":-0.0083,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":248,"spectrum_identification_item_id":24337,"charge":1,"index":37,"m_mz":3965.97,"m_intensity":23390000,"m_error":-0.007,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":249,"spectrum_identification_item_id":24337,"charge":1,"index":36,"m_mz":3878.93,"m_intensity":4996000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":250,"spectrum_identification_item_id":24337,"charge":1,"index":32,"m_mz":3459.71,"m_intensity":21840000,"m_error":-0.0048,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":251,"spectrum_identification_item_id":24337,"charge":1,"index":28,"m_mz":3069.55,"m_intensity":8877000,"m_error":-0.0072,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":252,"spectrum_identification_item_id":24337,"charge":1,"index":27,"m_mz":2954.53,"m_intensity":21940000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":253,"spectrum_identification_item_id":24337,"charge":1,"index":25,"m_mz":2755.43,"m_intensity":17380000,"m_error":-0.006,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":254,"spectrum_identification_item_id":24337,"charge":1,"index":24,"m_mz":2698.41,"m_intensity":20280000,"m_error":-0.0052,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":255,"spectrum_identification_item_id":24337,"charge":1,"index":22,"m_mz":2496.33,"m_intensity":7171000,"m_error":-0.0041,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":256,"spectrum_identification_item_id":24337,"charge":1,"index":18,"m_mz":2083.07,"m_intensity":29990000,"m_error":-0.0043,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":257,"spectrum_identification_item_id":24337,"charge":1,"index":17,"m_mz":1954.03,"m_intensity":11550000,"m_error":-0.0037,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":258,"spectrum_identification_item_id":24337,"charge":1,"index":14,"m_mz":1537.77,"m_intensity":6256000,"m_error":-0.0023,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":259,"spectrum_identification_item_id":24337,"charge":1,"index":13,"m_mz":1423.73,"m_intensity":7062000,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":260,"spectrum_identification_item_id":24337,"charge":1,"index":12,"m_mz":1308.71,"m_intensity":6381000,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":261,"spectrum_identification_item_id":24337,"charge":1,"index":11,"m_mz":1195.62,"m_intensity":972500,"m_error":-0.0017,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":262,"spectrum_identification_item_id":24337,"charge":1,"index":10,"m_mz":1124.58,"m_intensity":1199000,"m_error":-0.0015,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":263,"spectrum_identification_item_id":24337,"charge":1,"index":9,"m_mz":1053.55,"m_intensity":2309000,"m_error":0.003,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":264,"spectrum_identification_item_id":24337,"charge":1,"index":7,"m_mz":762.389,"m_intensity":7506000,"m_error":-0.0012,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":265,"spectrum_identification_item_id":24337,"charge":1,"index":5,"m_mz":505.253,"m_intensity":810600,"m_error":-0.0005,"fragment_type":"frag: z+1 ion","psi_ms_cv_fragment_type_accession":"MS:1001367"},
   {"id":266,"spectrum_identification_item_id":24337,"charge":1,"index":107,"m_mz":11752.3,"m_intensity":4613000,"m_error":-0.02,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"},
   {"id":267,"spectrum_identification_item_id":24337,"charge":1,"index":50,"m_mz":5454.78,"m_intensity":11680000,"m_error":-0.0154,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"},
   {"id":268,"spectrum_identification_item_id":24337,"charge":1,"index":44,"m_mz":4750.44,"m_intensity":4836000,"m_error":-0.015,"fragment_type":"frag: z+2 ion","psi_ms_cv_fragment_type_accession":"MS:1001368"}
  ]

  i = 0
  while i < jsonFragmentIons.length
    if jsonFragmentIons[i].fragment_type == "frag: c ion"
      jsonFragmentIons[i].color = "steelblue"
    else if jsonFragmentIons[i].fragment_type == "frag: z+1 ion"
     jsonFragmentIons[i].color = "red" 
    i++

  ##Dynamically Adjusting SVG Container Space:
#  max_x = 0
#  max_y = 0  
#  i = 0
#  while i < jsonRectangles.length  
#    temp_x = jsonRectangles[i].x_axis + jsonRectangles[i].width
#    temp_y = jsonRectangles[i].y_axis + jsonRectangles[i].height 
#    max_x = temp_x  if temp_x >= max_x
#    max_y = temp_y  if temp_y >= max_y
#    i++
#  max_x
#  max_y
#  svgContainer = d3.select("content").append("svg")
#                                     .attr("width", max_x + 20)
#                                     .attr("height", max_y + 20)
#                                     .style("border", "1px solid black");



  #SET UP svgContainer--------------------------------------------
  w = 650
  h = 350
  padding = 70
  svgContainer = d3.select("content").append("svg")
                                     .attr("width", w)
                                     .attr("height", h)
                                     #.style("border", "1px solid black")
                                     .style("margin", "1% 5%");



  #SCALING thing----------------------------------------------------
  maxInitialMz = d3.max(jsonFragmentIons, (d) -> return d.m_mz)
  minInitialMz = d3.min(jsonFragmentIons, (d) -> return d.m_mz)  
  maxInitialIntensity = d3.max(jsonFragmentIons, (d) -> return d.m_intensity)
  minInitialIntensity = d3.min(jsonFragmentIons, (d) -> return d.m_intensity)
  
  xScale = d3.scale.linear() #Remember: When I say “input,” you say “domain.” Then I say “output,” and you say “range.” Ready?
                   .domain([minInitialMz, maxInitialMz])
                   .range([padding, w - padding]) 

  yScale = d3.scale.linear()
                   .domain([minInitialIntensity, maxInitialIntensity])
                   .range([padding, h - padding])  #Now that we’re using scales, it’s super easy to reverse that, so greater values are higher up, as you would expect (alignedleft/scales)
                   #.range([h - padding, padding])



  #SET UP Axis----------------------------------------------------
  
  xAxis = d3.svg.axis()
                 .scale(xScale)
                 .orient("bottom")
                 .ticks(5)
  svgContainer.append("g")
                .attr("class", "axis")
                .attr("transform", "translate(0," + (h - padding) + ")")
                .call(xAxis)
                
  yAxis = d3.svg.axis()
                 .scale(yScale)
                 .orient("left")
                 .ticks(5)
                 .tickFormat((d) -> '')
  svgContainer.append("g")
               .attr("class", "axis")
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
    
  #ADD MS BARS (RECT OR LINE ???) --------------------------------
  msBars = svgContainer.selectAll("line")
                           .data(jsonFragmentIons)
                           .enter()
                           .append("line")
                           
  msBarText = svgContainer.selectAll("text")
                          .data(jsonFragmentIons)
                          .enter()
                          .append("text")

  msBarAttributes = msBars
                     .attr("x1", (d) -> return xScale(d.m_mz) )
                     .attr("y1", h - padding)
                     .attr("x2", (d) -> return xScale(d.m_mz) )
                     .attr("y2", (d) -> return h - yScale(d.m_intensity) )
                     .attr("stroke-width", 1)
                     .attr("stroke", (d) -> return d.color)

  msBarTextLabels = msBarText
                     #.attr("transform", "rotate(90)")
                     .attr("x", (d) -> return xScale(d.m_mz) )
                     .attr("y", (d) -> return h - yScale(d.m_intensity) )
                     .text((d) -> return d.m_mz)
                     .attr("font-family", "sans-serif")
                     .attr("font-size", "9px")
                     .attr("fill", "gray")
                     
                     
