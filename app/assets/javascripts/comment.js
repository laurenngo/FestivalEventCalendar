$(function(){

  default_action = $('#default-action').val($('#new_comment').attr('action'));

    $('body').on('submit','#new_comment',function(e){

        e.preventDefault();

        var form = $(this)

        $.ajax({
          url: form.attr('action'),
          method: 'POST',
          data: form.serialize()
        }).done(function(data){
            form.trigger('reset');

            // var modal = UIKit.modal("#comment-reply-modal");
            form.closest('.uk-modal').hide()

            // if (modal.isActive()) {
            //   modal.hide();
            // } else {
            //   modal.show();
            // }

            $('.display-container').html(data)
        }).error(function(err){
          console.log(err)
        })

    })

    $('.display-container').on('click', '.reply-btn', function(e){

      e.preventDefault();

      var btn = $(this)

      // form.attr('action', $(this).attr('href')).children('#comment_body').focus();


        $.ajax({
          url: '/message/new',
          method: 'GET',
          data: {
            event_id: btn.attr('data_event'),
            comment_id: btn.attr('data_comment')
          }
        }).done(function(form){
          $('.reply-modal-body').html(form)
          if($(location).attr('pathname').indexOf('inbox') !== -1) {
            $('#new_comment').attr('id','new_comment_inbox');
          }
        }).error(function(err){
          console.log('ERROR', err)
        })




    })







  console.log("I AM READY!")

})