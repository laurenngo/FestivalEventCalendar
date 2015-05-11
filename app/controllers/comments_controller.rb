class CommentsController < ApplicationController

  before_action :is_authenticated?

#inbox
    def index
      @messages = Comment.where(commentable_id: @current_user.id, commentable_type: 'User').order(created_at: 'ASC')
      @sent = @current_user.comments.order(created_at: 'ASC').select { |c| c.commentable_type == 'User' }
    end

#create for comments & messages
#no new route - comments created on event show page

    def create
      # render json: message_params
      # return
      @event = Event.find params[:event_id] if params.key?(:event_id)
        # friend = User.find(params[:user_id]) if params.key(:user_id)

      if params.key? :comment_id
        if params.key? :user_id
          @current_user.comments << Comment.find(params[:comment_id]).comments.create(message_params)
          render partial: 'layouts/message', locals: {message:Comment.find(params[:comment][:original])}
          return
        else
          @current_user.comments << Comment.find(params[:comment_id]).comments.create(comment_params)
        end
      elsif params.key? :user_id
        @current_user.comments << User.find(params[:user_id]).messages.create(message_params)
        redirect_to inbox_path
        return
      else
        @current_user.comments << @event.comments.create(comment_params)
      end

      render :partial => 'layouts/comment_display', :collection => @event.comments

    end

#individual messages
    def show
      @message = Comment.find params[:id]
    end

#delete messages
    def destroy
    end


    private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def message_params
      info = params.require(:comment).permit(:subject,:body)
      info[:original_id] = params[:user_id]
      info[:unread] = true
      info
    end

end