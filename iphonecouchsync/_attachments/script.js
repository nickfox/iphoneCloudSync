var db = $.couch.db(getCurrentDBName());

function getCurrentDBName() {
    return window.location.pathname.split("/")[1];
}

$(document).ready(function() {
    
    // init page
	clearForm();
    refreshItems();
	$('#productName').focus();
	    
    // create new product
    $('input#createButton').click(function(e) {
       	var productName = $('#productName').val();

       	if ($('#productName').val().length == 0) {
		   	alert("Product name is required.");
			$('#productName').focus();
           	return;
       	}

       	if ($('#productDescription').val().length == 0) {
		   	alert("Product description is required.");
			$('#productDescription').focus();
           	return;
       	}
       
       var aTask = {  
			name: $('#productName').val(),
			description: $('#productDescription').val(),
			image: $('#productImage').val()
		}
       
       db.saveDoc(aTask, { success: function(resp) {
	 		$('#messages').html(productName + ' created.');
           	refreshItems();
       }});

      clearForm();
    });

	// update product
    $('input#updateButton').click(function(e) {
		var productName = $('#productName').val();
    	
       if ($('#productName').val().length == 0) {
		   alert("Product name is required.");
			$('#productName').focus();
           return;
       }
 
       if ($('#productDescription').val().length == 0) {
		   	alert("Product description is required.");
			$('#productDescription').focus();
           	return;
       }
      		
       var aTask = {
           	_id: $('#productID').val(),
           	_rev: $('#productRev').val(),
           	name: $('#productName').val(),
			description: $('#productDescription').val(),
			image: $('#productImage').val()
       }

       db.saveDoc(aTask, { success: function(resp) {
			$('#messages').html(productName + ' updated.');
           	refreshItems();

			$('#productRev').val(resp.rev);
       }});
    });

	// delete product
    $('input#deleteButton').click(function(e) {
		var productName = $('#productName').val();
         
       if ($('#productID').val().length == 0) {
           return;
       }
       
       var aTask = {
           _id: $('#productID').val(),
           _rev: $('#productRev').val()
       }

       db.removeDoc(aTask, { success: function(resp) {
			$('#messages').html(productName + ' deleted.');
			refreshItems();
       }});
       
       clearForm();
    });

	// clear fields
	$('input#clearButton').click(function(e) {
		clearForm();
		$('#productName').focus();
	});
});

function refreshItems() {
    $("ul#productData").empty();
      
    db.view("iphonecouchsync/myView", {
        success: function(data){
            data.rows.map(function(row) {
            	$('ul#productData').append('<li id="' + row.value._id + '">'
                	+ row.value.name
                	+ '</li>');
            
				$("ul#productData").mouseover(function() {
				    $(this).css('cursor', 'pointer');
				});
         
   				$('#' + row.value._id).mouseover(function() {
                	$(this).addClass('hover');
            	}); 
        
   				$('#' + row.value._id).mouseout(function() {
                	$(this).removeClass('hover');
            	});

   				$('#' + row.value._id).click(function() {
					clearForm();
                	$('#productID').val(row.value._id);
                	$('#productRev').val(row.value._rev);
                	$('#productName').val(row.value.name);
					$('#productDescription').val(row.value.description);
					$('#productImage').val(row.value.image);
									
                	return false;
            	});
            });
        },
        error: function(req, textStatus, errorThrown){alert('Error: '+ textStatus);}
    });
}

function clearForm() {
    $('#productID').val('');
    $('#productRev').val('');
    $('#productName').val('');
    $('#productDescription').val('');
	$('#productImage').val('');
};