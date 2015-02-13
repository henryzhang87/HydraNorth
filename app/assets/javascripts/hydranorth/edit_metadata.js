Blacklight.onLoad(function() {

  var selopt = $("#generic_file_resource_type").val();

  if (selopt === undefined || selopt ===null){
      $(".form-group.generic_file_trid").css({ opacity: 0 });
      $(".form-group.generic_file_ser").css({ opacity: 0 });

  }else {
    id_based_on_resource_type;
  }


  function id_based_on_resource_type(){
    var seltype = $("#generic_file_resource_type").val()
    if (seltype == "Computing Science Technical Report") {
      $(".form-group.generic_file_trid").css({ opacity: 1 });
      $(".form-group.generic_file_ser").css({ opacity: 0 });
      if ($("#generic_file_trid").val() == "no_trid"){
        $("#generic_file_trid").val("");
      }
    } else if (seltype == "Structural Engineering Report") {
      $(".form-group.generic_file_trid").css({ opacity: 0 });
      $(".form-group.generic_file_ser").css({ opacity: 1 });
      if ($("#generic_file_ser").val() == "no_ser"){
        $("#generic_file_ser").val("");
      }
    } else {
      $(".form-group.generic_file_trid").css({ opacity: 0 });
      $(".form-group.generic_file_ser").css({ opacity: 0 });
    }

  }

  function set_value_invisible_field(){

    if ($(".form-group.generic_file_ser").css('opacity') == 0){
      $("#generic_file_ser").val("no_ser");
    }
    if ($(".form-group.generic_file_trid").css('opacity') == 0){
      $("#generic_file_trid").val("no_trid");
    }


  }

  $("#generic_file_resource_type").click(id_based_on_resource_type);
  $("#upload_submit").click(set_value_invisible_field());
  
  function get_autocomplete_opts(field) {
    var autocomplete_opts = {
      minLength: 2,
      source: function( request, response ) {
        $.getJSON( "/authorities/generic_files/" + field, {
          q: request.term
        }, response );
      },
      focus: function() {
        // prevent value inserted on focus
        return false;
      },
      complete: function(event) {
        $('.ui-autocomplete-loading').removeClass("ui-autocomplete-loading");
      }
    };
    return autocomplete_opts;
  }

    // there are two levels of vocabulary auto complete.
    // currently we have this externally hosted vocabulary
    // for geonames.  I'm not going to make these any easier
    // to implement for an external url (it's all hard coded)
    // because I'm guessing we'll get away from the hard coding
  var cities_autocomplete_opts = {
    source: function( request, response ) {
      $.ajax( {
        url: "http://ws.geonames.org/searchJSON",
        dataType: "jsonp",
        data: {
          featureClass: "P",
          style: "full",
          maxRows: 12,
          name_startsWith: request.term
        },
        success: function( data ) {        response( $.map( data.geonames, function( item ) {
            return {
              label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
              value: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName
            };
          }));
        },
      });
    },
    minLength: 2
  };
  $("#generic_file_spatial").autocomplete(get_autocomplete_opts("location"));

  var autocomplete_vocab = new Object();

  autocomplete_vocab.url_var = ['subject', 'language'];   // the url variable to pass to determine the vocab to attach to
  autocomplete_vocab.field_name = new Array(); // the form name to attach the event for autocomplete

  // loop over the autocomplete fields and attach the
  // events for autocomplete and create other array values for autocomplete
  for (var i=0; i < autocomplete_vocab.url_var.length; i++) {
    autocomplete_vocab.field_name.push('generic_file_' + autocomplete_vocab.url_var[i]);
    // autocompletes
    $("#" + autocomplete_vocab.field_name[i])
        // don't navigate away from the field on tab when selecting an item
        .bind( "keydown", function( event ) {
            if ( event.keyCode === $.ui.keyCode.TAB &&
                    $( this ).data( "autocomplete" ).menu.active ) {
                event.preventDefault();
            }
        })
        .autocomplete( get_autocomplete_opts(autocomplete_vocab.url_var[i]) );
  }


  // attach an auto complete based on the field
  function setup_autocomplete(e, cloneElem) {
    var $cloneElem = $(cloneElem);
    // FIXME this code (comparing the id) depends on a bug. Each input has an id and the id is
    // duplicated when you press the plus button. This is not valid html.
    if ($cloneElem.attr("id") == 'generic_file_spatial') {
      $cloneElem.autocomplete(cities_autocomplete_opts);
    } else if ( (index = $.inArray($cloneElem.attr("id"), autocomplete_vocab.field_name)) != -1 ) {
      $cloneElem.autocomplete(get_autocomplete_opts(autocomplete_vocab.url_var[index]));
    }
  }

  $('.multi_value.form-group').manage_fields({add: setup_autocomplete});
});
